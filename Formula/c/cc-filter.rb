class CcFilter < Formula
  desc "Claude Code Sensitive Information Filter"
  homepage "https://github.com/wissem/cc-filter"
  url "https://github.com/wissem/cc-filter/archive/refs/tags/v0.0.3.tar.gz"
  sha256 "7b8a196dd7ba360fa5c1bebb45e7145ee26f6f3993caaa015a68ac739fe3039a"
  license "MIT"
  revision 1
  head "https://github.com/wissem/cc-filter.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "725a537835555016b590629f2741093a5178facd6a6288c83ee49be432f8ba86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1065d93e121ee3280c1381736a4e1d05bed01b83c2f5762b4ce54dbf11c76063"
    sha256 cellar: :any_skip_relocation, ventura:       "06cb5f5514f0b942b8d2f6c331cabba563c0613dcae09e5930e4d2dc05fb95fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3be3bfa8e11f8cd1ec1562e9a9340641de14212d515e2a6f9d9a79a5add11734"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cc-filter --version")

    output = pipe_output("#{bin}/cc-filter", "API_KEY=secret123", 0)
    assert_match "API_KEY=secret123", output
    assert_path_exists testpath/".cc-filter/filter.log"
  end
end
