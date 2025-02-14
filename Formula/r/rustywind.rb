class Rustywind < Formula
  desc "CLI for organizing Tailwind CSS classes"
  homepage "https://github.com/avencera/rustywind"
  url "https://github.com/avencera/rustywind/archive/refs/tags/v0.23.1.tar.gz"
  sha256 "d7ba13370721df4cc6728ca6b956f9a92ab260de08c03ef445a105a87e382546"
  license "Apache-2.0"
  head "https://github.com/avencera/rustywind.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "361bf6fe91ef6cde756450fa5a5eda41f749d70f27fe6f51643460359fcec8c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b83780bcda68c96802dce615f8238601c0594a2896f793c346d776c5884447f5"
    sha256 cellar: :any_skip_relocation, ventura:       "5008a6817081c8e5e08b192968cef2621bf2f22af8bfa88d07d0bbff606521d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f2ad5575d5dba4fcb9268dda429b957617ceb71d844b52abc765ca34c58efab"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rustywind-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rustywind --version")

    (testpath/"test.html").write <<~HTML
      <div class="text-center bg-red-500 text-white p-4">
        <p class="text-lg font-bold">Hello, World!</p>
      </div>
    HTML

    system bin/"rustywind", "--write", "test.html"

    expected_content = <<~HTML
      <div class="p-4 text-center text-white bg-red-500">
        <p class="text-lg font-bold">Hello, World!</p>
      </div>
    HTML

    assert_equal expected_content, (testpath/"test.html").read
  end
end
