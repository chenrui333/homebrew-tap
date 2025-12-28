class FlintCli < Formula
  desc "Lightweight tool for managing linux virtual machines"
  homepage "https://github.com/ccheshirecat/flint"
  url "https://github.com/ccheshirecat/flint/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "4b302cb4d72f7978747c49fb4f400c4cf838d15674738d8e042b98dc7e43fcf9"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2bb91a62e833f2e432512a93aa732e507da92c5675921d0869d36641c81ebf1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "922b8b52101c6b7616d0fd28a4d23060d763dd5451141f6303bd69dcaeb8a0a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a978d360db4da494c4fc0761046a7408d5c1182c42273bbc1d1ab68eea40a076"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aea862a3e62494b1c3047b20935690a1b10b7e19891917fbbeed9829cea17912"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "libvirt"
  depends_on "qemu"

  def install
    cd "web" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
    end

    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"flint")

    generate_completions_from_executable(bin/"flint", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/flint api-key")
    assert_match "Use this key in the Authorization header", output
  end
end
