class Gix < Formula
  desc "Git, but with superpowers"
  homepage "https://github.com/ademajagon/gix"
  url "https://github.com/ademajagon/gix/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "4ef0bca5a27f17ef4bb46239a8a5a7c43e3f32aac9a76ef8821b04b53f6d4e64"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "423baf2773ecf0a1c8d6cdb8c6b32967d7e80e62c33ba43e4a36c57d83b22ed5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "423baf2773ecf0a1c8d6cdb8c6b32967d7e80e62c33ba43e4a36c57d83b22ed5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "423baf2773ecf0a1c8d6cdb8c6b32967d7e80e62c33ba43e4a36c57d83b22ed5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d4b6ab6ed77b8419a423ac24635f5d8e9930d16d92f4ebd6a80eb2db2eaa235"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e16b443f979c3f7be3370ccef3acda0d1274d986674515011e3bb5f605c72002"
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
