class Streamtop < Formula
  desc "Terminal monitor for HLS, DASH and IPTV streams"
  homepage "https://github.com/Jorji49/streamtop"
  url "https://github.com/Jorji49/streamtop/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "ddaec44657109ab228cfbc7d064331882d36281f026f6e624eb985c334167d78"
  license "MIT"
  head "https://github.com/Jorji49/streamtop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97230ae71e3ba259a920727faa451064eb7a54d76f5fcd3a11181bb1cfd96b84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f81570e9961899729dc572820da22f53c22619ecf54a8fa7dbe2c488342b22f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41e83970718118f71b616babe31fc807726746c42e51d7c42a955dd36e88e82e"
    sha256 cellar: :any,                 arm64_linux:   "abfc224fe1570c64045b3af4d935e5dee3759bb1c5cfe4e0a5da43307caa335f"
    sha256 cellar: :any,                 x86_64_linux:  "d41edda5b8d2ad4d4b0a1e67cb4407bbb699650e549cb2ee221c720b854962e2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"streamtop", "--agent", etc/"streamtop.toml"]
    log_path var/"log/streamtop.log"
    error_log_path var/"log/streamtop.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/streamtop --version")
    (testpath/"empty.toml").write("streams = []\n")
    output = shell_output("#{bin}/streamtop --agent #{testpath}/empty.toml 2>&1", 1)
    assert_match "agent config has no [[streams]] entries", output
  end
end
