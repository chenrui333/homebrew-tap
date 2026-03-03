class Gix < Formula
  desc "Git, but with superpowers"
  homepage "https://github.com/ademajagon/gix"
  url "https://github.com/ademajagon/gix/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "4ef0bca5a27f17ef4bb46239a8a5a7c43e3f32aac9a76ef8821b04b53f6d4e64"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7ebea85f3b3098c256f3aa789141a9514e100173fb8e045c7ac20ec53f32d8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7ebea85f3b3098c256f3aa789141a9514e100173fb8e045c7ac20ec53f32d8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7ebea85f3b3098c256f3aa789141a9514e100173fb8e045c7ac20ec53f32d8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "789316f4ac83ff0e66df36a184365ea99c954e2e4b6d654597de5d8370ad0df5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d45ceb12554d81ea5042cf061892102aef9406bed2eee6b3a21a45e6e0d27d62"
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
