class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.52.0.tar.gz"
  sha256 "d295652578640fe98e4c56a4e75f42cfd13b30df922447e8c27285dc1b83565a"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7dd3ae9e5635c8c26715ac598aff9e8809dff42d2f1738f48d6f1ea373b03908"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7dd3ae9e5635c8c26715ac598aff9e8809dff42d2f1738f48d6f1ea373b03908"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7dd3ae9e5635c8c26715ac598aff9e8809dff42d2f1738f48d6f1ea373b03908"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64f661eb2f908cebf458ffaf25a2126c885ac5939b9ee3cde893fe34ed5bc966"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c87d39b9756ae08a435d448d38b056bc7022b17594bb16005abe816cb44b5f3a"
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
