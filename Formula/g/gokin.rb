class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.54.2.tar.gz"
  sha256 "d79e4abfd2beb3e3970ed5858307035187a3cd0b574b360c9d51cfc4a8622240"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "390ab6187545bfb33ba5a92faae32f4ecac4a102bdd176ecd1944d81ac073221"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "390ab6187545bfb33ba5a92faae32f4ecac4a102bdd176ecd1944d81ac073221"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "390ab6187545bfb33ba5a92faae32f4ecac4a102bdd176ecd1944d81ac073221"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae37962515936987a7b1d1f6466e69451d6d367ca6a4a40aaa59855a920f3034"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b237bb9c7da976698aca1d486ae4ceb34d8ec61f4b3ac196ba0ef3bbaac4a16b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    assert_match "Available Commands:", shell_output("#{bin}/gokin --help")
  end
end
