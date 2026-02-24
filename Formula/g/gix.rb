class Gix < Formula
  desc "Git, but with superpowers"
  homepage "https://github.com/ademajagon/gix"
  url "https://github.com/ademajagon/gix/archive/refs/tags/v0.2.10.tar.gz"
  sha256 "bcabb53c87e1a5c0de42027be0d2af2c6b3563f7eb5be61870f089874b5b3a81"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a18b676008799b3b0320158d8ee3450d524a89b815f6e8453b84d3e14946f6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a18b676008799b3b0320158d8ee3450d524a89b815f6e8453b84d3e14946f6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a18b676008799b3b0320158d8ee3450d524a89b815f6e8453b84d3e14946f6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5011a47fea429e9e03f52b39c9c42f79b1f56b7746150b4bce2c862a906673b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12ba78a45cb64215d9e196b889cc2f1b59717f557b35fc8e595d769dd25244a0"
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
