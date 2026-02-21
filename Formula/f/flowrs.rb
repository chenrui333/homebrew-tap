class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "5f1d4cf2562cb7046f005953567d9f0c9c1ee739415e39b9f46982f5904fb885"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1318a4cbbf6194ba7972d2d32d331136786601799609b06dd8cd3a0efad799e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98ed33dbe3cb6519bc5f348f3dfa2ea708505e1e6b3e3a02deac51efce3580cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdf33afd60efe30c05cfaa31276ee0f5278dea50d0ae7e3430cf29014b767166"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "765d2a79479448a3925e1c222a31c5e76edaedde6cc84843f20dd2d25a360777"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef211b4147b23adbfd9a54800ac7e6ff2ab66d66039ca2ae2dc312543caae1fc"
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
