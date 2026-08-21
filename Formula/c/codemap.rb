class Codemap < Formula
  desc "Generate a brain map of a codebase for LLM context"
  homepage "https://github.com/JordanCoin/codemap"
  url "https://github.com/JordanCoin/codemap/archive/refs/tags/v4.4.1.tar.gz"
  sha256 "781b77da5bc436370c5cb9d6847168d75ba1be363304ea6f9b055d69d8503f2f"
  license "MIT"
  head "https://github.com/JordanCoin/codemap.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7a5440fbc4d60da1e1a361de33e878c2c2e42b1ea073d29be5ab2e7332c9173"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7a5440fbc4d60da1e1a361de33e878c2c2e42b1ea073d29be5ab2e7332c9173"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7a5440fbc4d60da1e1a361de33e878c2c2e42b1ea073d29be5ab2e7332c9173"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40215ea716e612c2cce438d48dfb1018eb322ebb5e12c4720e7d8fc6a42d0097"
    sha256 cellar: :any,                 x86_64_linux:  "ffabcfe2b46ca237fc848fa2b2d3e085f06054c1f208982cad3dff2f7d924702"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"hello.go").write <<~EOS
      package main
      func main() {}
    EOS

    output = shell_output("#{bin}/codemap --json #{testpath}")
    assert_match "\"path\":\"hello.go\"", output
  end
end
