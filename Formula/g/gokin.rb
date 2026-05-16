class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.82.3.tar.gz"
  sha256 "cb69f10709782ed1efb41550c18099ec6c65521d6005c61710df9bb26d0b471c"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "464dea1b8e8d9497cbdd426169697824434d1d15acafd48a69c047a4a9f7cd02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "464dea1b8e8d9497cbdd426169697824434d1d15acafd48a69c047a4a9f7cd02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "464dea1b8e8d9497cbdd426169697824434d1d15acafd48a69c047a4a9f7cd02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bdf9d71e35d109396e0d8514479b237751979f3b0f1a3e5d2b191409159fea4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1db57f93d48f806b6fcd28bd6f88c60c1dc435c2b152bb7f58ecd2c622ca59bf"
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
