class FlintCli < Formula
  desc "Lightweight tool for managing linux virtual machines"
  homepage "https://github.com/ccheshirecat/flint"
  url "https://github.com/ccheshirecat/flint/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "c021f81f89a1d67e8804aebecd21b74f722e120361de4d4b9f8f5bbcde6d720c"
  license "Apache-2.0"

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

    generate_completions_from_executable(bin/"flint", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    output = shell_output("#{bin}/flint api-key")
    assert_match "Use this key in the Authorization header", output
  end
end
