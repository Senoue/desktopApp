//go:build ignore
// +build ignore

package main

import (
	"fmt"
	"os"
	"os/exec"
)

func main() {
	// Windows向けビルド（コンソールなし）
	cmdWindows := exec.Command("go", "build", "-ldflags", "-H=windowsgui", "-o", "app.exe", ".")
	cmdWindows.Stdout = os.Stdout
	cmdWindows.Stderr = os.Stderr
	fmt.Println("Building for Windows (no console)...")
	if err := cmdWindows.Run(); err != nil {
		fmt.Printf("Error building for Windows: %v\n", err)
		os.Exit(1)
	}
	fmt.Println("Build completed: app.exe")
}
