class Hyprmoncfg < Formula
  desc "Terminal-first monitor configurator and daemon for Hyprland"
  homepage "https://hyprmoncfg.dev/"
  url "https://github.com/crmne/hyprmoncfg/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "7fddb75af20d408340ee2e4eb5a8df72151a136e385635ac3391ca8fe128a701"
  license "MIT"
  head "https://github.com/crmne/hyprmoncfg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "611969206eb10cd846fb1793a5bd9908be7ea65ef411a65ba14cb4eeefffc648"
    sha256 cellar: :any,                 x86_64_linux: "b25ba6da5b929bd0d3812c182b11bab72568d5ddf229711bea1199106fb6fb6e"
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
