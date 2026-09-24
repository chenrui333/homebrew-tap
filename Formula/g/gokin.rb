class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.100.141.tar.gz"
  sha256 "6a77a879247a7d558480b7f4659a070547326169741fad74a27fd3cbd3068c53"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5abab7644bf83bbf1ff1ac53d73378e99600ccd498b7d5a76e4458ae8de33433"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "236a31693030491d1033c46618ffbd72b034ca300b12ddf0298d8ec4e1b5a253"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "baf6066e627c027472f548ad708202bce4c42dc960cc109dd8b45bfc0c29c75b"
    sha256 cellar: :any,                 x86_64_linux:  "e187f2d423e6785dba903bc79b917f2c6044f1b02af694853fade753e9dd071a"
  end

  depends_on "go" => :build

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
