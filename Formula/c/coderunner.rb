class Coderunner < Formula
  desc "Secure local sandbox to run LLM-generated code using Apple containers"
  homepage "https://github.com/instavm/coderunner"
  url "https://github.com/instavm/coderunner/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "f292b6c18f01985382f51f40ad5c2fe0e91cf2f3121a7295b8f2294610b02312"
  license "MIT"

  depends_on arch: :arm64
  depends_on :macos
  depends_on "python@3.13"

  def install
    system "python3", "-m", "pip", "install", "--prefix=#{prefix}", "--no-deps", "."
  end
end
