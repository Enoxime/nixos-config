_: {
  programs.k9s = {
    enable = true;
    aliases = {
      aliases = {
        dp = "deployments";
        sec = "v1/secrets";
        jo = "jobs";
        cr = "clusterroles";
        crb = "clusterrolebindings";
        ro = "roles";
        rb = "rolebindings";
        np = "networkpolicies";
      };
    };

    settings = {
      k9s = {
        ui = {
          headless = false;
          logoless = true;
        };
      };
      clusters = {
        k8s00 = {
          shellPod = {
            image = "cool_kid_admin:42";
            namespace = "admin-tools";
            limits = {
              cpu = "100m";
              memory = "100Mi";
            };
          };
          featureGates = {
            nodeShell = true;
          };
        };
      };
    };

    plugins = {
      cert-status = {
        shortCut = "Shift-S";
        confirm = false;
        description = "Certificate status";
        scopes = [
          "certificates"
        ];
        command = "bash";
        background = false;
        args = [
          "-c"
          "cmctl status certificate --context $CONTEXT -n $NAMESPACE $NAME |& less"
        ];
      };
      cert-renew = {
        shortCut = "Shift-R";
        confirm = false;
        description = "Certificate renew";
        scopes = [
          "certificates"
        ];
        command = "bash";
        background = false;
        args = [
          "-c"
          "cmctl renew --context $CONTEXT -n $NAMESPACE $NAME |& less"
        ];
      };
      secret-inspect = {
        shortCut = "Shift-I";
        confirm = false;
        description = "Inspect secret";
        scopes = [
          "secrets"
        ];
        command = "bash";
        background = false;
        args = [
          "-c"
          "cmctl inspect secret --context $CONTEXT -n $NAMESPACE $NAME |& less"
        ];
      };

      #--- Create debug container for selected pod in current namespace
      # See https://kubernetes.io/docs/tasks/debug/debug-application/debug-running-pod/#ephemeral-container
      debug = {
        shortCut = "Shift-D";
        description = "Add debug container";
        dangerous = true;
        scopes = [
          "containers"
        ];
        command = "bash";
        background = false;
        confirm = true;
        args = [
          "-c"
          "kubectl --kubeconfig=$KUBECONFIG debug -it --context $CONTEXT -n=$NAMESPACE $POD --target=$NAME --image=nicolaka/netshoot:v0.13 --share-processes -- bash"
        ];
      };

      # https://github.com/wagoodman/dive
      dive = {
        shortCut = "d";
        confirm = false;
        description = "Dive image";
        scopes = [
          "containers"
        ];
        command = "dive";
        background = false;
        args = [
          "$COL-IMAGE"
        ];
      };

      # Duplicate Pods, Deployments and StatefulSet for easy debugging
      # and troubleshooting.
      #
      # See https://github.com/Telemaco019/duplik8s
      duplicate-pod = {
        shortCut = "Ctrl-B";
        description = "Duplicate Pod";
        scopes = [
          "po"
        ];
        command = "kubectl";
        background = true;
        args = [
          "duplicate"
          "pod"
          "$NAME"
          "-n"
          "$NAMESPACE"
          "--context"
          "$CONTEXT"
        ];
      };
      duplicate-deployment = {
        shortCut = "Ctrl-T";
        description = "Duplicate Deployment";
        scopes = [
          "deploy"
        ];
        command = "kubectl";
        background = true;
        args = [
          "duplicate"
          "deploy"
          "$NAME"
          "-n"
          "$NAMESPACE"
          "--context"
          "$CONTEXT"
        ];
      };
      duplicate-statefulset = {
        shortCut = "Ctrl-T";
        description = "Duplicate StatefulSet";
        scopes = [
          "statefulset"
        ];
        command = "kubectl";
        background = true;
        args = [
          "duplicate"
          "statefulset"
          "$NAME"
          "-n"
          "$NAMESPACE"
          "--context"
          "$CONTEXT"
        ];
      };

      # https://external-secrets.io/latest/
      refresh-external-secrets = {
        shortCut = "Shift-R";
        confirm = false;
        scopes = [
          "externalsecrets"
        ];
        description = "Refresh the externalsecret";
        command = "bash";
        background = false;
        args = [
          "-c"
          "kubectl annotate externalsecrets.external-secrets.io -n $NAMESPACE $NAME force-sync=$(date +%s) --overwrite"
        ];
      };
      refresh-push-secrets = {
        shortCut = "Shift-R";
        confirm = false;
        scopes = [
          "pushsecrets"
        ];
        description = "Refresh the pushsecret";
        command = "bash";
        background = false;
        args = [
          "-c"
          "kubectl annotate pushsecrets.external-secrets.io -n $NAMESPACE $NAME force-sync=$(date +%s) --overwrite"
        ];
      };

      # $HOME/.k9s/plugin.yml
      # move selected line to chosen resource in K9s, then:
      # Shift-T (with confirmation) to toggle helm releases or kustomizations suspend and resume
      # Shift-R (no confirmation) to reconcile a git source or a helm release or a kustomization
      toggle-helmrelease = {
        shortCut = "Shift-T";
        confirm = true;
        scopes = [
          "helmreleases"
        ];
        description = "Toggle to suspend or resume a HelmRelease";
        command = "bash";
        background = false;
        args = [
          "-c"
          ''suspended=$(kubectl --context $CONTEXT get helmreleases -n $NAMESPACE $NAME -o=custom-columns=TYPE:.spec.suspend | tail -1);
          verb=$([ $suspended = "true" ] && echo "resume" || echo "suspend");
          flux
          $verb helmrelease
          --context $CONTEXT
          -n $NAMESPACE $NAME
          | less -K''
        ];
      };
      toggle-kustomization = {
        shortCut = "Shift-T";
        confirm = true;
        scopes = [
          "kustomizations"
        ];
        description = "Toggle to suspend or resume a Kustomization";
        command = "bash";
        background = false;
        args = [
          "-c"
          ''suspended=$(kubectl --context $CONTEXT get kustomizations -n $NAMESPACE $NAME -o=custom-columns=TYPE:.spec.suspend | tail -1);
          verb=$([ $suspended = "true" ] && echo "resume" || echo "suspend");
          flux
          $verb kustomization
          --context $CONTEXT
          -n $NAMESPACE $NAME
          | less -K''
        ];
      };
      reconcile-git = {
        shortCut = "Shift-R";
        confirm = false;
        description = "Flux reconcile";
        scopes = [
          "gitrepositories"
        ];
        command = "bash";
        background = false;
        args = [
          "-c"
          ''flux
          reconcile source git
          --context $CONTEXT
          -n $NAMESPACE $NAME
          | less -K''
        ];
      };
      reconcile-hr = {
        shortCut = "Shift-R";
        confirm = false;
        description = "Flux reconcile";
        scopes = [
          "helmreleases"
        ];
        command = "bash";
        background = false;
        args = [
          "-c"
          ''flux
          reconcile helmrelease
          --context $CONTEXT
          -n $NAMESPACE $NAME
          | less -K''
        ];
      };
      reconcile-helm-repo = {
        shortCut = "Shift-Z";
        description = "Flux reconcile";
        scopes = [
          "helmrepositories"
        ];
        command = "bash";
        background = false;
        confirm = false;
        args = [
          "-c"
          ''flux
          reconcile source helm
          --context $CONTEXT
          -n $NAMESPACE $NAME
          | less -K''
        ];
      };
      reconcile-oci-repo = {
        shortCut = "Shift-Z";
        description = "Flux reconcile";
        scopes = [
          "ocirepositories"
        ];
        command = "bash";
        background = false;
        confirm = false;
        args = [
          "-c"
          ''flux
          reconcile source oci
          --context $CONTEXT
          -n $NAMESPACE $NAME
          | less -K''
        ];
      };
      reconcile-ks = {
        shortCut = "Shift-R";
        confirm = false;
        description = "Flux reconcile";
        scopes = [
          "kustomizations"
        ];
        command = "bash";
        background = false;
        args = [
          "-c"
          ''flux
          reconcile kustomization
          --context $CONTEXT
          -n $NAMESPACE $NAME
          | less -K''
        ];
      };
      reconcile-ir = {
        shortCut = "Shift-R";
        confirm = false;
        description = "Flux reconcile";
        scopes = [
          "imagerepositories"
        ];
        command = "sh";
        background = false;
        args = [
          "-c"
          ''flux
          reconcile image repository
          --context $CONTEXT
          -n $NAMESPACE $NAME
          | less -K''
        ];
      };
      reconcile-iua = {
        shortCut = "Shift-R";
        confirm = false;
        description = "Flux reconcile";
        scopes = [
          "imageupdateautomations"
        ];
        command = "sh";
        background = false;
        args = [
          "-c"
          ''flux
          reconcile image update
          --context $CONTEXT
          -n $NAMESPACE $NAME
          | less -K''
        ];
      };
      trace = {
        shortCut = "Shift-P";
        confirm = false;
        description = "Flux trace";
        scopes = [
          "all"
        ];
        command = "bash";
        background = false;
        args = [
          "-c"
          ''resource=$(echo $RESOURCE_NAME | sed -E 's/ies$/y/' | sed -E 's/ses$/se/' | sed -E 's/(s|es)$//g');
          flux
          trace
          --context $CONTEXT
          --kind $resource
          --api-version $RESOURCE_GROUP/$RESOURCE_VERSION
          --namespace $NAMESPACE $NAME
          | less -K''
        ];
      };
      # credits: https://github.com/fluxcd/flux2/discussions/2494
      get-suspended-helmreleases = {
        shortCut = "Shift-S";
        confirm = false;
        description = "Suspended Helm Releases";
        scopes = [
          "helmrelease"
        ];
        command = "sh";
        background = false;
        args = [
          "-c"
          ''kubectl get
          --context $CONTEXT
          --all-namespaces
          helmreleases.helm.toolkit.fluxcd.io -o json
          | jq -r '.items[] | select(.spec.suspend==true) | [.metadata.namespace,.metadata.name,.spec.suspend] | @tsv'
          | less -K''
        ];
      };
      get-suspended-kustomizations = {
        shortCut = "Shift-S";
        confirm = false;
        description = "Suspended Kustomizations";
        scopes = [
          "kustomizations"
        ];
        command = "sh";
        background = false;
        args = [
          "-c"
          ''kubectl get
          --context $CONTEXT
          --all-namespaces
          kustomizations.kustomize.toolkit.fluxcd.io -o json
          | jq -r '.items[] | select(.spec.suspend==true) | [.metadata.name,.spec.suspend] | @tsv'
          | less -K''
        ];
      };

      #get all resources in a namespace using the krew get-all plugin
      get-all-namespace = {
        shortCut = "g";
        confirm = false;
        description = "get-all";
        scopes = [
          "namespaces"
        ];
        command = "sh";
        background = false;
        args = [
          "-c"
          "kubectl get-all --context $CONTEXT -n $NAME | less -K"
        ];
      };
      get-all-other = {
        shortCut = "g";
        confirm = false;
        description = "get-all";
        scopes = [
          "all"
        ];
        command = "sh";
        background = false;
        args = [
          "-c"
          "kubectl get-all --context $CONTEXT -n $NAMESPACE | less -K"
        ];
      };

      helm-default-values = {
        shortCut = "Shift-V";
        confirm = false;
        description = "Chart Default Values";
        scopes = [
          "helm"
        ];
        command = "sh";
        background = false;
        args = [
          "-c"
          ''revision=$(helm history -n $NAMESPACE --kube-context $CONTEXT $COL-NAME | grep deployed | cut -d$'\t' -f1 | tr -d ' \t');
          kubectl
          get secrets
          --context $CONTEXT
          -n $NAMESPACE
          sh.helm.release.v1.$COL-NAME.v$revision -o yaml
          | yq e '.data.release' -
          | base64 -d
          | base64 -d
          | gunzip
          | jq -r '.chart.values'
          | yq -P
          | less -K''
        ];
      };

      # Requires helm-diff plugin installed: https://github.com/databus23/helm-diff
      # In helm view: <Shift-D> Diff with Previous Revision
      # In helm-history view: <Shift-Q> Diff with Current Revision
      helm-diff-previous = {
        shortCut = "Shift-D";
        confirm = false;
        description = "Diff with Previous Revision";
        scopes = [
          "helm"
        ];
        command = "bash";
        background = false;
        args = [
          "-c"
          ''LAST_REVISION=$(($COL-REVISION-1));
          helm diff revision $COL-NAME $COL-REVISION $LAST_REVISION --kube-context $CONTEXT --namespace $NAMESPACE --color | less -RK''
        ];
      };
      helm-diff-current = {
        shortCut = "Shift-Q";
        confirm = false;
        description = "Diff with Current Revision";
        scopes = [
          "history"
        ];
        command = "bash";
        background = false;
        args = [
          "-c"
          ''RELEASE_NAME=$(echo $NAME | cut -d':' -f1);
          LATEST_REVISION=$(helm history -n $NAMESPACE --kube-context $CONTEXT $RELEASE_NAME | grep deployed | cut -d$'\t' -f1 | tr -d ' \t');
          helm diff revision $RELEASE_NAME $LATEST_REVISION $COL-REVISION --kube-context $CONTEXT --namespace $NAMESPACE --color | less -RK''
        ];
      };

      # Issues a helm delete --purge for the resource associated with the selected pod
      # Requires https://github.com/derailed/k9s/blob/master/plugins/kubectl/kubectl-purge
      # See https://kubernetes.io/docs/tasks/extend-kubectl/kubectl-plugins/
      helm-purge = {
        shortCut = "Ctrl-P";
        description = "Helm Purge";
        dangerous = true;
        scopes = [
          "po"
        ];
        command = "kubectl";
        background = true;
        args = [
          "purge"
          "$NAMESPACE"
          "$NAME"
        ];
      };

      # View user-supplied values when the helm chart was created
      helm-values = {
        shortCut = "Ctrl-V";
        confirm = false;
        description = "Values";
        scopes = [
          "helm"
        ];
        command = "sh";
        background = false;
        args = [
          "-c"
          "helm get values $COL-NAME -n $NAMESPACE --kube-context $CONTEXT | less -K"
        ];
      };

      # Suspends/Resumes a cronjob
      toggleCronjob = {
        shortCut = "Ctrl-S";
        confirm = true;
        dangerous = true;
        scopes = [
          "cj"
        ];
        description = "Toggle to suspend or resume a running cronjob";
        command = "kubectl";
        background = true;
        args = [
          "patch"
          "cronjobs"
          "$NAME"
          "-n"
          "$NAMESPACE"
          "--context"
          "$CONTEXT"
          "-p"
          "'{\"spec\" : {\"suspend\" : $!COL-SUSPEND }}'"
        ];
      };

      # liveMigration plugin config by rabin-io
      #
      # Trigger virtual machine live migration, for VM's running on k8s cluster using kubevirt
      #  or Openshift with CNV (OpenShift Virtualization) installed.
      #
      # Require `virtctl` cli in your PATH,
      #   can be downloaded from Openshift `Command Line Tools` page
      #   or from kubevirt site https://kubevirt.io/user-guide/operations/virtctl_client_tool/
      #
      #
      liveMigration = {
        # Can be triggered from the VMI (VirtualMachineInstance) view, with shortcut `m`
        shortCut = "m";
        # Description to show in K9s menu
        description = "Live Migrate moves VM to another compute node";
        # Enable confirmation dialog
        confirm = true;
        dangerous = true;
        # Collections of views that support this shortcut. (You can use `all`)
        scopes = [
          "virtualmachineinstance"
        ];
        # Whether or not to run the command in background mode
        background = false;
        # The command to run upon invocation.
        command = "virtctl";
        # Defines the command arguments
        args = [
          "migrate"
          "$NAME"
          "-n"
          "$NAMESPACE"
          "--context"
          "$CONTEXT"
        ];
      };

      # Logs management
      raw-logs-follow = {
        shortCut = "Ctrl-G";
        description = "logs -f";
        scopes = [
          "po"
        ];
        command = "kubectl";
        background = false;
        args = [
          "logs"
          "-f"
          "$NAME"
          "-n"
          "$NAMESPACE"
          "--context"
          "$CONTEXT"
          "--kubeconfig"
          "$KUBECONFIG"
        ];
      };
      log-less = {
        shortCut = "Shift-K";
        description = "logs|less";
        scopes = [
          "po"
        ];
        command = "bash";
        background = false;
        args = [
          "-c"
          "'\"$@\" | less'"
          "dummy-arg"
          "kubectl"
          "logs"
          "$NAME"
          "-n"
          "$NAMESPACE"
          "--context"
          "$CONTEXT"
          "--kubeconfig"
          "$KUBECONFIG"
        ];
      };
      log-less-container = {
        shortCut = "Shift-L";
        description = "logs|less";
        scopes = [
          "containers"
        ];
        command = "bash";
        background = false;
        args = [
          "-c"
          "'\"$@\" | less'"
          "dummy-arg"
          "kubectl"
          "logs"
          "-c"
          "$NAME"
          "$POD"
          "-n"
          "$NAMESPACE"
          "--context"
          "$CONTEXT"
          "--kubeconfig"
          "$KUBECONFIG"
        ];
      };

      # Sends logs over to jq for processing. This leverages kubectl plugin kubectl-jq.
      jqlogs = {
        shortCut = "Ctrl-J";
        confirm = false;
        description = "Logs (jq)";
        scopes = [
          "po"
        ];
        command = "kubectl";
        background = false;
        args = [
          "jq"
          "$NAME"
          "$NAMESPACE"
          "$CONTEXT"
        ];
      };

      # Leverage stern (https://github.com/stern/stern) to output logs.
      # See https://github.com/stern/stern
      stern = {
        shortCut = "Ctrl-Y";
        confirm = false;
        description = "Logs <Stern>";
        scopes = [
          "pods"
        ];
        command = "stern";
        background = false;
        args = [
          "--tail"
          "50"
          "$FILTER"
          "-n"
          "$NAMESPACE"
          "--context"
          "$CONTEXT"
        ];
      };

      node-root-shell = {
        shortCut = "a";
        description = "Run root shell on node";
        dangerous = true;
        scopes = [
          "nodes"
        ];
        command = "bash";
        background = false;
        confirm = true;
        args = [
          "-c"
          ''host="$1"
          json='
          {
            "apiVersion": "v1",
            "spec": {
              "hostIPC": true,
              "hostNetwork": true,
              "hostPID": true
          '
          if ! [[ -z "$host" ]]; then
            json+=",
            \"nodeSelector\" : {
              \"kubernetes.io/hostname\" : \"$host\"
            }
            ";
          fi
          json+='
            }
          }
          '
          kubectl run \
            -ti \
            --image alpine:3.8 \
            --rm \
            --privileged \
            --restart=Never \
            --overrides="$json" root \
              --command -- nsenter -t 1 -m -u -n -i -- bash -l''
        ];
      };

      # Inspect certificate chains with openssl.
      # See: https://github.com/openssl/openssl.
      secret-openssl-ca = {
        shortCut = "Ctrl-O";
        confirm = false;
        description = "Openssl ca.crt";
        scopes = [
          "secrets"
        ];
        command = "bash";
        background = false;
        args = [
          "-c"
          ''kubectl get secret \
            --context $CONTEXT \
            -n $NAMESPACE $NAME \
            -o jsonpath='{.data.ca\.crt}' \
          | base64 -d \
          | openssl storeutl -noout -text -certs /dev/stdin \
          |& less''
        ];
      };
      secret-openssl-tls = {
        shortCut = "Shift-O";
        confirm = false;
        description = "Openssl tls.crt";
        scopes = [
          "secrets"
        ];
        command = "bash";
        background = false;
        args = [
          "-c"
          ''kubectl get secret \
            --context $CONTEXT \
            -n $NAMESPACE $NAME \
            -o jsonpath='{.data.tls\.crt}' \
          | base64 -d \
          | openssl storeutl -noout -text -certs /dev/stdin |& less''
        ];
      };

      # Removes all finalizers from the selected resource. Finalizers are namespaced keys that tell Kubernetes to wait
      # until specific conditions are met before it fully deletes resources marked for deletion.
      # Before deleting an object you need to ensure that all finalizers has been removed. Usually this would be done
      # by the specific controller but under some circumstances it is possible to encounter a set of objects blocked
      # for deletion.
      # This plugin makes this task easier by providing a shortcut to directly removing them all.
      # Be careful when using this plugin as it may leave dangling resources or instantly deleting resources that were
      # blocked by the finalizers.
      # Author: github.com/jalvarezit
      remove_finalizers = {
        shortCut = "Ctrl-F";
        confirm = true;
        dangerous = true;
        scopes = [
          "all"
        ];
        description = "Removes all finalizers from selected resource. Be careful when using it,
          it may leave dangling resources or delete them";
        command = "kubectl";
        background = true;
        args = [
          "patch"
          "--context"
          "$CONTEXT"
          "--namespace"
          "$NAMESPACE"
          "$RESOURCE_NAME.$RESOURCE_GROUP"
          "$NAME"
          "-p"
          "'{\"metadata\":{\"finalizers\":null}}'"
          "--type"
          "merge"
        ];
      };

      # Author: Daniel Rubin
      # Get recommendations for CPU/Memory requests and limits using Robusta KRR
      # Requires Prometheus in the Cluster and Robusta KRR (https://github.com/robusta-dev/krr) on your system
      # Open K9s in deployments/daemonsets/statefulsets view, then:
      # Shift-K to get recommendations
      krr = {
        shortCut = "Shift-K";
        description = "Get krr";
        scopes = [
          "deployments"
          "daemonsets"
          "statefulsets"
        ];
        command = "bash";
        background = false;
        confirm = false;
        args = [
          "-c"
          ''LABELS=$(kubectl get $RESOURCE_NAME $NAME \
              -n $NAMESPACE \
              --context $CONTEXT \
              --show-labels \
            | awk '{print $NF}' \
            | awk '{if(NR>1)print}'
          )
          krr simple --cluster $CONTEXT --selector $LABELS 
          echo "Press 'q' to exit"
          while : ; do
          read -n 1 k <&1
          if [[ $k = q ]] ; then
          break
          fi
          done''
        ];
      };

      # remove finalizers from a stuck namespace
      rm-ns = {
        shortCut = "n";
        confirm = true;
        dangerous = true;
        description = "Remove NS Finalizers";
        scopes = [
          "namespace"
        ];
        command = "sh";
        background = false;
        args = [
          "-c"
          ''kubectl get namespace $NAME -o json \
          | jq '.spec.finalizers=[]' \
          | kubectl replace --raw /api/v1/namespaces/$NAME/finalize -f - > /dev/null''
        ];
      };

      # Author: Qasim Sarfraz
      # Trace DNS requests for containers, pods, and nodes
      # Requires kubectl version 1.30 or later
      # https://github.com/inspektor-gadget/inspektor-gadget
      # https://www.inspektor-gadget.io/docs/latest/gadgets/trace_dns
      trace-dns = {
        shortCut = "Shift-D";
        description = "Trace DNS requests";
        scopes = [
          "containers"
          "pods"
          "nodes"
        ];
        command = "bash";
        confirm = false;
        background = false;
        args = [
          "-c"
          ''IG_VERSION=v0.34.0
          IG_IMAGE=ghcr.io/inspektor-gadget/ig:$IG_VERSION
          IG_FIELD=k8s.podName,src,dst,qr,qtype,name,rcode,latency_ns
          
          GREEN='\033[0;32m'
          RED='\033[0;31m'
          BLUE='\033[0;34m'
          NC='\033[0m' # No Color
          
          # Ensure kubectl version is 1.30 or later
          KUBECTL_VERSION=$(kubectl version --client | awk '/Client Version:/{print $3}')
          if [[ "$(echo "$KUBECTL_VERSION" | cut -d. -f2)" -lt 30 ]]; then
            echo -e "''${RED}kubectl version 1.30 or later is required''${NC}"
            sleep 3
            exit
          fi
          
          clear

          # Handle containers
          if [[ -n "$POD" ]]; then
            echo -e "''${GREEN}Tracing DNS requests for container ''${BLUE}''${NAME}''${GREEN} in pod ''${BLUE}''${POD}''${GREEN} in namespace ''${BLUE}''${NAMESPACE}''${NC}"
            IG_NODE=$(kubectl get pod "$POD" -n "$NAMESPACE" -o jsonpath='{.spec.nodeName}')
            kubectl debug --kubeconfig=$KUBECONFIG  --context=$CONTEXT -q \
              --profile=sysadmin "node/$IG_NODE" -it --image="$IG_IMAGE" -- \
              ig run trace_dns:$IG_VERSION -F "k8s.podName==$POD" -F "k8s.containerName=$NAME" \
              --fields "$IG_FIELD"
              exit
          fi
          
          # Handle pods
          if [[ -n "$NAMESPACE" ]]; then
            echo -e "''${GREEN}Tracing DNS requests for pod ''${BLUE}''${NAME}''${GREEN} in namespace ''${BLUE}''${NAMESPACE}''${NC}"
            IG_NODE=$(kubectl get pod "$NAME" -n "$NAMESPACE" -o jsonpath='{.spec.nodeName}')
            kubectl debug --kubeconfig=$KUBECONFIG  --context=$CONTEXT -q \
              --profile=sysadmin  -it --image="$IG_IMAGE" "node/$IG_NODE" -- \
              ig run trace_dns:$IG_VERSION -F "k8s.podName==$NAME" \
              --fields "$IG_FIELD"
              exit
          fi
          
          # Handle nodes
          echo -e "''${GREEN}Tracing DNS requests for node ''${BLUE}''${NAME}''${NC}"
          kubectl debug --kubeconfig=$KUBECONFIG  --context=$CONTEXT -q \
            --profile=sysadmin -it --image="$IG_IMAGE" "node/$NAME" -- \
            ig run trace_dns:$IG_VERSION --fields "$IG_FIELD"''
        ];
      };

      # watch events on selected resources
      # requires linux "watch" command
      # change '-n' to adjust refresh time in seconds
      watch-events = {
        shortCut = "Shift-E";
        confirm = false;
        description = "Get Events";
        scopes = [
          "all"
        ];
        command = "sh";
        background = false;
        args = [
          "-c"
          ''kubectl events \
            --context $CONTEXT \
            --namespace $NAMESPACE \
            --for $RESOURCE_NAME.$RESOURCE_GROUP/$NAME \
            --watch''
        ];
      };
    };
  };
}
