class Gix < Formula
  desc "Git, but with superpowers"
  homepage "https://github.com/ademajagon/gix"
  url "https://github.com/ademajagon/gix/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "4436cb0f26c608bbf4774210422a66a25b27ea8775260373b6b81a52e97bf94a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "430ae8b74c394a58772a77ea8507dc0f8ad02a713c6b7e1206443f3365d5fa58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "430ae8b74c394a58772a77ea8507dc0f8ad02a713c6b7e1206443f3365d5fa58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "430ae8b74c394a58772a77ea8507dc0f8ad02a713c6b7e1206443f3365d5fa58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca1eb7b67631432ea5d168f785b4daf423a3ee0966682b518c6103abdba6c9ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d60d45c1bb2bdacdc4a8c041ac8c4e5aff999a1abc6f5f3c6671c8a33235e45d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/ademajagon/gix/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gix", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gix --version")

    (testpath/"test.txt").write("Hello World!")
    system "git", "init"
    system "git", "add", "test.txt"

    output = shell_output("#{bin}/gix commit 2>&1", 1)
    assert_match "config not found - run `gix config set-key`", output
  end
end
