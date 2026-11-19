class Hyprmoncfg < Formula
  desc "Terminal-first monitor configurator and daemon for Hyprland"
  homepage "https://hyprmoncfg.dev/"
  url "https://github.com/crmne/hyprmoncfg/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "1690ece4357f1313456d26d5cd5325c44494c7bd614d8fcd8f87b02ad4e85870"
  license "MIT"
  head "https://github.com/crmne/hyprmoncfg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "b1f5e76122e495376f9d9440e7a92ae59b88338c58578015a41e95936dd58cd8"
    sha256 cellar: :any,                 x86_64_linux: "149c68f41dd772b38a184310a6a4687413f3de9e835a4952cb843348bd499c24"
  end

  depends_on "go" => :build
  depends_on :linux

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/crmne/hyprmoncfg/internal/buildinfo.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/hyprmoncfg"
    system "go", "build", *std_go_args(ldflags:, output: bin/"hyprmoncfgd"), "./cmd/hyprmoncfgd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hyprmoncfg version")

    # `profiles` only needs hyprctl on PATH; listing reads the local profile store.
    (testpath/"bin/hyprctl").write "#!/bin/sh\nexit 0\n"
    chmod 0755, testpath/"bin/hyprctl"
    ENV.prepend_path "PATH", testpath/"bin"
    assert_match "No saved profiles", shell_output("#{bin}/hyprmoncfg --config-dir #{testpath}/cfg profiles")
    assert_predicate testpath/"cfg/profiles", :directory?
  end
end
