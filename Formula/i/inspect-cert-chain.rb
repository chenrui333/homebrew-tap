class InspectCertChain < Formula
  desc "Inspect and debug TLS certificate chains (without OpenSSL)"
  homepage "https://github.com/robjtede/inspect-cert-chain"
  url "https://github.com/robjtede/inspect-cert-chain/archive/refs/tags/v0.0.43.tar.gz"
  sha256 "971e344e5180b938641b2c7c18a36ff8aae30912ef23672334ee619590cdfa91"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/robjtede/inspect-cert-chain.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b3a92fb21c9ff0c88376f7af7f96b7f5a09f295cbbdf0939ad1f10c4eee443c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f77bcce968e278c8265f034d35fc3426bf815614642166c1632e9c3abe6b896"
    sha256 cellar: :any,                 arm64_linux:   "7cd65991ebceefac4107a53e0dc4c86960ac7de6085afe267f1129e2f2509a41"
    sha256 cellar: :any,                 x86_64_linux:  "3ecd65209851a18ad314f474781f3e614a143efef919efae86cf86ce52216128"
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
