class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.100.90.tar.gz"
  sha256 "e1f1f63a4b2f2dbc6cf0eef8e801d02537eb156d9ec0ab9743763ee4d85b2378"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fab8c51bdc044c85d9eeace8ab66aedc8ed789136e03a844d1cd0378c9c3530b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fab8c51bdc044c85d9eeace8ab66aedc8ed789136e03a844d1cd0378c9c3530b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fab8c51bdc044c85d9eeace8ab66aedc8ed789136e03a844d1cd0378c9c3530b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cfa6c72992044f679ea399fbe5e5f6e0e71bc8c55a63994b413c37b6f831012"
    sha256 cellar: :any,                 x86_64_linux:  "2ed743970e098fa41494e69da1bbe4d9752bd23a9d20bb8e3a21f9830dd2a57a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    output = shell_output("#{bin}/gokin not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
