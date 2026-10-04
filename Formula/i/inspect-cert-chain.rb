class InspectCertChain < Formula
  desc "Inspect and debug TLS certificate chains (without OpenSSL)"
  homepage "https://github.com/robjtede/inspect-cert-chain"
  url "https://github.com/robjtede/inspect-cert-chain/archive/refs/tags/v0.0.43.tar.gz"
  sha256 "971e344e5180b938641b2c7c18a36ff8aae30912ef23672334ee619590cdfa91"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/robjtede/inspect-cert-chain.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "edfbf4e05be91cfbe12eac5793b01a53d11c60fc40a9bd00b97f5e839d765ad8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a9ad92a51b3a4ae5bca8013ff8acbedac50e00ffd56e8f36468bbe8e4edd58d"
    sha256 cellar: :any,                 arm64_linux:   "3320d63f5e3f2451fcf99cbe9e0eb96487a946ffe302945a7d6fdfe6300cfdb8"
    sha256 cellar: :any,                 x86_64_linux:  "7afcf0be9d02b4ee2c77428baa30d666ebd07193db88d50983905c26032b3bc3"
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
