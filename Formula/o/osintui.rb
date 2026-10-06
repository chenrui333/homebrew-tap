class Osintui < Formula
  desc "Open Source Intelligence Terminal User Interface"
  homepage "https://docs.rs/crate/osintui/latest"
  url "https://static.crates.io/crates/osintui/osintui-0.1.1.crate"
  sha256 "732444225882845e6148e0fcc1ab4351454180014eb605f2133c490a1314b703"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1dd2358a7d155c2394086ebe900596c4d4d0e700b962d96281938ea4ee728bcc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2ae5aa3fa68ca31819e1aae34c9fe77a14dc93c34d99a8e3b2dec9fea153455"
    sha256 cellar: :any,                 arm64_linux:   "207a42abf37489c49ee7bfac05c27d0e3c8ac4bd44f079df4e5e8c1a13dfb10f"
    sha256 cellar: :any,                 x86_64_linux:  "9d2825b00ca112ede9a0056386555d29a3762489a20503ad4f9e0b5306ac6aa8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output_log = testpath/"output.log"
    pid = spawn bin/"osintui", [:out, :err] => output_log.to_s
    sleep 1
    assert_match "Config will be saved to", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
