class Gix < Formula
  desc "Git, but with superpowers"
  homepage "https://github.com/ademajagon/gix"
  url "https://github.com/ademajagon/gix/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "bc8301ebb6b6b83445d4b8f99ed451c7a68b396bac8bc7059fe5ea5497881535"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d74cef3880bf2036a01fd4266c483371405c6dbfda2d4a2bb330a9618e7e2013"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f603542c53c38fddd4d9d80abe505985b31781de5d6e756b73ad4f315753e6c"
    sha256 cellar: :any_skip_relocation, ventura:       "c0633c09b81d1c0b662efba563f3cf1b452f3d9901e6c36723d951851eceeab0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b94b4d935911e5332ec03385c40f6157a3dfed59f3a2df11304a88fc8d36a1d9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/ademajagon/gix/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gix", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gix version")

    (testpath/"test.txt").write("Hello World!")
    system "git", "init"
    system "git", "add", "test.txt"

    output = shell_output("#{bin}/gix commit 2>&1", 1)
    assert_match "error: config not loaded: config file not found", output
  end
end
