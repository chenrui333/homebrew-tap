class Urlhunter < Formula
  desc "Recon tool that allows searching on URLs that are exposed via shortener services"
  homepage "https://github.com/utkusen/urlhunter"
  url "https://github.com/utkusen/urlhunter/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "ef7d6719d9a824a5614808c9408bd3dd73dda1049feaa7f65442b1c44602aa13"
  license "MIT"
  head "https://github.com/utkusen/urlhunter.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/urlhunter --keywords #{testpath}/keywords.txt --date 2024-01-01 2>&1", 2)
    assert_match "[ERROR]: Error processing archive", output
  end
end
