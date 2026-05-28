class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.85.8.tar.gz"
  sha256 "e2b9cdd7d3e237ad600a07ee01bce7d0c9b771660b7f403a53a80632ed3758a1"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22098ce568d46fa102a054d06ba8fbe3ec5977c12e6f1dc3b9b16dadc74aec74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22098ce568d46fa102a054d06ba8fbe3ec5977c12e6f1dc3b9b16dadc74aec74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22098ce568d46fa102a054d06ba8fbe3ec5977c12e6f1dc3b9b16dadc74aec74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b14232fa555eff453854e844d8a1da195088552f2abe2bc6a4947ff64555e515"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4ae165bdf433122dc67cfb34ecfb39f27a48e5b12de820189e135c654638d5e"
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
