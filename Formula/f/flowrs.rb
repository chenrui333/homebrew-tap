class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "ec2f5f04ec77d7c63cf40da03570d2593ba23a60e835c94102efa9b2caaa9aa5"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb8ce7fa374a1f487a3362dc25e003c3567cce6705e315855011016988ac129f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed992332d6acb318cb0a324cb3e8425696b22c010af5ee25402eac12de479f5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a2a08dca21ca416aad5770a9a41a77162d57eaa533a622c02f95c6692d4573d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "676624ae1095185fe6a7f3c882285a1fd682341d3d3af79869ae8b83d85b143e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0df076afd6129e8ef37cc6cb8c56376359494b9ff5abe81010fd8f94ca813926"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end
