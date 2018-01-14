package client

import (
	_ "k8s.io/api/core/v1"
	_ "k8s.io/apiextensions-apiserver/pkg/apis/apiextensions/v1beta1"
	_ "k8s.io/apimachinery/pkg/util/wait"
	_ "k8s.io/client-go/rest"
)
