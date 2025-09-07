_: {
  home = {
    sessionPath = [
      "$HOME/.kube/plugins/bin"
    ];
    
    file = {
      kubectl-purge = {
        enable = true;
        executable = true;
        target = "./.kube/plugins/bin/kubectl-purge";
        text = ''
          #!/usr/bin/env bash

          usage="kubectl $(basename "$0") [-h] NAMESPACE NAME
          kubectl plugin, requires TILLER_NS set before call. Will run helm delete --purge on release associated with pod.
          Release is acquired from the pod's 'describe' information in the 'tags' section.
          Examples:
            kubectl purge my-namespace my-namespace-pod1-123: Purge the release associated with 'my-namespace-pod1-123' pod"
          
          while getopts ':h' option; do
            case "$option" in
              h) echo "$usage"
                exit
                ;;
            esac
          done
          shift $((OPTIND -1))

          namespace=$1
          name=$2
          if [ -z "$TILLER_NS" ]; then
            echo "Set TILLER_NS environment variable before calling this function"
            exit 1;
          elif [ -z "$namespace" ]; then
            echo "No Namespace provided"
            exit 1;
          elif [ -z "$name" ]; then
            echo "No Name provided"
            exit 1;
          fi

          kubectl describe pods -n $namespace $name \
            | grep release \
            | cut -f 2 -d'=' \
            | xargs -J rel helm --tiller-namespace $TILLER_NS delete --purge rel

        '';
      };

      kubectl-jq = {
        enable = true;
        executable = true;
        target = "./.kube/plugins/bin/kubectl-jq";
        text = ''
          #!/usr/bin/env bash

          kubectl logs \
            -f $1 \
            -n $2 \
            --context $3 \
          | jq -rR '. as $raw \
          | try (fromjson | .message) catch ("\u001b[31m" + $raw + "\u001b[0m")'
        '';
      };
    };
  };
}
