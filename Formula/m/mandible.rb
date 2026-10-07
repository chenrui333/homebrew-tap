class Mandible < Formula
  desc "Interactive reference for installed command-line tools"
  homepage "https://github.com/AS-FOSS/mandible"
  url "https://github.com/AS-FOSS/mandible/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "2b27891c9d6ec872cb4287c9d5eac5d17e699cd90be35702a63d04ffd5a7c661"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/AS-FOSS/mandible.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "995973c1e79359ecf613a556f67e3eb52bf9e80479d7d66469b5b88be4e67f23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f16b713ee9440f71d3021b05cd3bb166414cda4dd99dc0bdea65f2f08a694a53"
    sha256 cellar: :any,                 arm64_linux:   "993200685e2af5269c04042c89ce01b1a4f46b2c5de5705506225375f6143da3"
    sha256 cellar: :any,                 x86_64_linux:  "df5ba08886632c66b8449b49f5b6b2d241649b7743b8d64ca2cc338acc5672e5"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "mandible")
    generate_completions_from_executable(bin/"mandible", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mandible --version")
    output = shell_output("#{bin}/mandible 2>&1", 1)
    assert_match "no tool given", output
  end
end
