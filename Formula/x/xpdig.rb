class Xpdig < Formula
  desc "Dig into Crossplane traces via TUI"
  homepage "https://github.com/brunoluiz/xpdig"
  url "https://github.com/brunoluiz/xpdig/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "0ec9c51fa4b701b6c400d45a92e801ba502233c0b01193d43c7f2df3d8ff830f"
  license "Apache-2.0"
  head "https://github.com/brunoluiz/xpdig.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7fba7177d35cdc336249e24886a08cb8b18dcca3bb39945e1fba27931c3dcc6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7fba7177d35cdc336249e24886a08cb8b18dcca3bb39945e1fba27931c3dcc6"
    sha256 cellar: :any,                 arm64_linux:   "aab39efe3f798e5a0856e2aadb5f28f15e82c0009cc44b7346f708b853df7347"
    sha256 cellar: :any,                 x86_64_linux:  "e13d677dd9ca18e4a584c2e5f1f259be435ea40febd1443fe24d448cea643efb"
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
