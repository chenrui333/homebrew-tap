class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.102.1.tar.gz"
  sha256 "2fb121b94ba2f5b49efb314f36d5554798fe3abdb6a7f656f69246e579257d98"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6ed64765943ef3ecd62e0d7fb1b93c46cac9ef18cc51412a15a0a3f15b0be35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00c7175d989cd22858a18946976f78803e41a6b9c9e5b214242a99c74fada218"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a17ed46355476dd1bb2c75ecb67e62f89133261787709df2e584837967c66323"
    sha256 cellar: :any,                 x86_64_linux:  "ccd84233cfd6db93d9e400626537c78e0d2870972a7705871479240334d0bc5b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    assert_match "API key not configured", shell_output("#{bin}/gokin doctor")
  end
end
