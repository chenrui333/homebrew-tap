class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.100.47.tar.gz"
  sha256 "ba41faab8bc87914d851d97146d1cec49ffd7a8361898dc387705c4af0283c87"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5934c37a284d582fcecdd70c20ed12fafb07cda510966a3df3e06f55e0ce7163"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5934c37a284d582fcecdd70c20ed12fafb07cda510966a3df3e06f55e0ce7163"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5934c37a284d582fcecdd70c20ed12fafb07cda510966a3df3e06f55e0ce7163"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25f21e89c5518f2287b2d2f00b8c9a3926f31dbcfc3e0f03b6d891dea4efe2f7"
    sha256 cellar: :any,                 x86_64_linux:  "c1154e954e49d042768184c5e8bf6a09f6758d6f355be969b8c282183f427815"
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
