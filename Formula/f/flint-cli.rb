class FlintCli < Formula
  desc "Lightweight tool for managing linux virtual machines"
  homepage "https://github.com/ccheshirecat/flint"
  url "https://github.com/ccheshirecat/flint/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "ede6b3cf83a8f727bc2ec07cb1dfece8a94b29fdc8fd6bcbeffdbc73637fa518"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bf643667990d21fc0df165db1b11febdf0d6e47e8f2d78e209ebd0b5338a269"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2b8dd83e58a619a2b20d9b562de9c6cd8657fbe0b39680eb9b204b54a05f15c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b32e0ec9cebdc5ab75b6e97bc576ead42d52b46fa7aeb24d5317cf9e497120eb"
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

    generate_completions_from_executable(bin/"flint", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    output = shell_output("#{bin}/flint api-key")
    assert_match "Use this key in the Authorization header", output
  end
end
