class Codespelunker < Formula
  desc "Command-line codespelunker or code search"
  homepage "https://github.com/boyter/cs"
  url "https://github.com/boyter/cs/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "faad9f1cdae00e4093d5750cfbe094b8b5c41650e8f439c5035c4b5f292eb45b"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/boyter/cs.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6cc4b6dbd1b7d464d6431326eb1742f79708e5e180831a632f622609761f281e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cc4b6dbd1b7d464d6431326eb1742f79708e5e180831a632f622609761f281e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57088094fba032cb54ddd8b49ab9322d9100cf2262c21e30db605929ebe900e6"
    sha256 cellar: :any,                 x86_64_linux:  "b547b85f71b171676d0e54c412270a263d2c7e491674c53837ef143db9fc040d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codespelunker --version")

    test_file = testpath/"test.txt"
    test_file.write <<~EOS
      This is a test file
      to test the code spelunker
      functionality.
    EOS

    output = shell_output("#{bin}/codespelunker --dir #{testpath} -f vimgrep test")
    assert_match "#{test_file}:1:0", output
  end
end
