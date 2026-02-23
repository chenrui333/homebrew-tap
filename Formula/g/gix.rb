class Gix < Formula
  desc "Git, but with superpowers"
  homepage "https://github.com/ademajagon/gix"
  url "https://github.com/ademajagon/gix/archive/refs/tags/v0.2.9.tar.gz"
  sha256 "45a8269fe6d2898e30885cc65c3fc12bdbf1018c8dd61b3feb1d537aec6d530f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee67ad4583a9074e08354266f9eb2f8b3dd68cc03fc6dcb6317cdc0cf74cccb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee67ad4583a9074e08354266f9eb2f8b3dd68cc03fc6dcb6317cdc0cf74cccb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee67ad4583a9074e08354266f9eb2f8b3dd68cc03fc6dcb6317cdc0cf74cccb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a1cdd96c649a9802e8b4adafdef9092dbf631b438f9dcd18e1bdc21430c83b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a0978dc2f1226ca8ac2c814a2e510e3b4dfa1d1699e628603a7c83c2d8c28a9"
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
