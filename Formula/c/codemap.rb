class Codemap < Formula
  desc "Generate a brain map of a codebase for LLM context"
  homepage "https://github.com/JordanCoin/codemap"
  url "https://github.com/JordanCoin/codemap/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "50dbdea5426ca26d8291293d1b3c3f7bb2080deb25fc6b4a31a2ae1780a441c5"
  license "MIT"
  head "https://github.com/JordanCoin/codemap.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c9cc8e8446830a90610681433ec0eb5397b4d7ddf16fa6bd45525cbc11dfd11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c9cc8e8446830a90610681433ec0eb5397b4d7ddf16fa6bd45525cbc11dfd11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c9cc8e8446830a90610681433ec0eb5397b4d7ddf16fa6bd45525cbc11dfd11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a88c5c63b6c0121fd870349e6f652a94806eeec4851396798adc7456c14ea738"
    sha256 cellar: :any,                 x86_64_linux:  "38f2d76d093ea39efd7bf06a54eea5084ba18fc56e8e66520052250efd40aae6"
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
