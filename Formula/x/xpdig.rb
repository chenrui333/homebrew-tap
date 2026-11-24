class Xpdig < Formula
  desc "Dig into Crossplane traces via TUI"
  homepage "https://github.com/brunoluiz/xpdig"
  url "https://github.com/brunoluiz/xpdig/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "2a6d4562f49b4320b7fe665a8208c25ec0aaa4f4df2672d23b5ee40786d8a2db"
  license "Apache-2.0"
  head "https://github.com/brunoluiz/xpdig.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "8a92d195d6bb7542ee586d042bdd72a73def376ba147638c572db276ee82e9a4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4002bdfcb3d66c49dda8bf3c3314379618964307bfbf90f246ab48f2896f2fdd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4002bdfcb3d66c49dda8bf3c3314379618964307bfbf90f246ab48f2896f2fdd"
    sha256 cellar: :any,                 arm64_linux:   "308f57aef4d2040baa60efbef626c32800efaca4be6d0046b4b948236a0533e7"
    sha256 cellar: :any,                 x86_64_linux:  "27c7b3e1a0aa5ea40d00038b642416224c68d25ab15aad96bbfddf1447731c59"
  end

  depends_on "go" => :build
  depends_on "crossplane"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # TODO: Remove when kube-openapi supports Go 1.27 jsonv2: https://github.com/brunoluiz/xpdig/issues/70
    ENV["GOEXPERIMENT"] = "nojsonv2"
    ENV["CGO_ENABLED"] = "1"

    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/xpdig"
  end

  test do
    version_output = shell_output("#{bin}/xpdig version")
    assert_match version.to_s, version_output

    # Concrete negative-path command to prove the binary handles bad input cleanly.
    invalid_output = shell_output("#{bin}/xpdig not-a-real-command 2>&1", 3)
    assert_match "No help topic for 'not-a-real-command'", invalid_output
    refute_match "panic:", invalid_output
  end
end
