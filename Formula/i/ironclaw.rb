class Ironclaw < Formula
  desc "Security-first personal AI assistant with WASM sandbox channels"
  homepage "https://github.com/nearai/ironclaw"
  url "https://github.com/nearai/ironclaw/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "e60ef7e056f643ccdd7ae0437abd64bad5884ecffde62edac85e2ebd31ec71b8"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/nearai/ironclaw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bad8b82a52b501bad0d16362c75eed9fe43366a67f685fc0461d92ef234a9819"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73114ac30c6860b870ba6fc60874323765944122c388b7a3bd5ae7009f172e71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3180167bab32d340653f99f62209b2da7883e00b27cc5f6efdfc98ba6e2b186f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6190384985c8c60fbae6051483a7e394c35cb135db9c37d7723c23ba8ee8b925"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9bf71a629938c49a8bf9ae23f3dec6e9c31de3d790068089a885065be04349e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"ironclaw", "run"]
    keep_alive true
  end

  test do
    ENV["HOME"] = testpath

    assert_match version.to_s, shell_output("#{bin}/ironclaw --version")
    assert_match "Settings", shell_output("#{bin}/ironclaw config list")
  end
end
