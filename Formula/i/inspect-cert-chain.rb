class InspectCertChain < Formula
  desc "Inspect and debug TLS certificate chains (without OpenSSL)"
  homepage "https://github.com/robjtede/inspect-cert-chain"
  url "https://github.com/robjtede/inspect-cert-chain/archive/refs/tags/v0.0.44.tar.gz"
  sha256 "61ea5ec7f6ed0dc26d009083b22ba9e672ca30969ffa6b457fc4cbeaabfaf5db"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/robjtede/inspect-cert-chain.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07547ebb06a1c9278453295afc28831295c61f4f2a708fe76e31fda3758bdd04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8117453ecf2e064ae778b3d14013c543a6e864ffeb52172836d39597ab6fb46a"
    sha256 cellar: :any,                 arm64_linux:   "d047ff04b45f3049649e81d1bff302dba6a2cf1025cd4cf3b15efab9f6c283db"
    sha256 cellar: :any,                 x86_64_linux:  "80a6c057f600d1fc54b27eb985bca794be5d2cf70d4506d95e877b5ffa623bd7"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["NO_COLOR"] = "1"

    assert_match version.to_s, shell_output("#{bin}/inspect-cert-chain --version")

    # Self-signed localhost certificate from upstream tests/fixtures/server.pem
    (testpath/"server.pem").write <<~PEM
      -----BEGIN CERTIFICATE-----
      MIIBnDCCAUGgAwIBAgIUOA4/L9uhWvS2eC0/NL5gdeUBv3kwCgYIKoZIzj0EAwIw
      FDESMBAGA1UEAwwJbG9jYWxob3N0MCAXDTI2MTAwMTE3MjU0OFoYDzIxMjYwOTA3
      MTcyNTQ4WjAUMRIwEAYDVQQDDAlsb2NhbGhvc3QwWTATBgcqhkjOPQIBBggqhkjO
      PQMBBwNCAASQNn6U+HvIESv9njiWUfOv4NVWXXqb5rQWRA+LgF7Cr0DefNIYSmDx
      +jfR3s00qjt45D58UcUjtoqMxfNQoFHgo28wbTAdBgNVHQ4EFgQUMEMpA4/NTmVN
      48LCAiU89/1seZUwHwYDVR0jBBgwFoAUMEMpA4/NTmVN48LCAiU89/1seZUwDwYD
      VR0TAQH/BAUwAwEB/zAaBgNVHREEEzARgglsb2NhbGhvc3SHBH8AAAEwCgYIKoZI
      zj0EAwIDSQAwRgIhAJ0Hh3+XT1aATksG4dY6mQV93Pu3zuGFAxnJ1wLqruhmAiEA
      xb1L0Cw58Czoo6231F738JuRGkXporzY8bKgfmapjUA=
      -----END CERTIFICATE-----
    PEM

    output = shell_output("#{bin}/inspect-cert-chain --file #{testpath}/server.pem")
    output = output.gsub(/\e\[[0-9;]*m/, "") # Remove ANSI color codes
    assert_match "Subject: CN=localhost", output
    assert_match "Issuer: CN=localhost", output
  end
end
