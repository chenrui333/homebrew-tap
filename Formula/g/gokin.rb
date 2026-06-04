class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.86.8.tar.gz"
  sha256 "8590e681b87c8772645e89cc3a8d1ae9c1b48bd9c6f7c65fc98dc71e370c8a11"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "878f0465d1ffea562f97111a1b4b348ba655210caa969a7e9ac88c504e309665"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "878f0465d1ffea562f97111a1b4b348ba655210caa969a7e9ac88c504e309665"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "878f0465d1ffea562f97111a1b4b348ba655210caa969a7e9ac88c504e309665"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4286360451a4739064aefed6235d372b18f1f3888c4b795917ea54f087e4f2e7"
    sha256 cellar: :any,                 x86_64_linux:  "d28cb97875844e6755bebd1a94a40c4ab6b6cbcd7cc802327b25be4d308ee5c7"
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
