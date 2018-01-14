package cmd

import (
	"fmt"

	"github.com/dyhpoon/testargo"
	"github.com/spf13/cobra"
)

// CLINAME is the name of the cli
const CLINAME = "argo"

func init() {
	RootCmd.AddCommand(versionCmd)
}

var versionCmd = &cobra.Command{
	Use:   "version",
	Short: fmt.Sprintf("Print the version number of %s", CLINAME),
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Printf("%s versions %s\n", CLINAME, argo.FullVersion)
	},
}
