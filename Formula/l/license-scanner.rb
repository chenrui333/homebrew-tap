class LicenseScanner < Formula
  desc "Utility that provides an API and CLI to identify licenses and legal terms"
  homepage "https://github.com/CycloneDX/license-scanner"
  url "https://github.com/CycloneDX/license-scanner/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "0682560617d2481f7070dc2ed389bafad2ff6a23eb5074a65f49f24c3ad2142c"
  license "Apache-2.0"
  head "https://github.com/CycloneDX/license-scanner.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25b0ba6109812c994a665f7374c435eddc73f22fc9911809c62943a92df6844e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25b0ba6109812c994a665f7374c435eddc73f22fc9911809c62943a92df6844e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25b0ba6109812c994a665f7374c435eddc73f22fc9911809c62943a92df6844e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a3a98c4a12a15f0be41e09241a23e5ae633942144403d35ee8493e3bb52808b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2edf508388e34da6d0e59915d4713d773c8c8fea57b9730b8427e084edf2507"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Upstream hardcodes the version as a Go const, so ldflags cannot set it.
    inreplace "cmd/root.go", 'currentVersion = "0.0.0"', "currentVersion = \"#{version}\""

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/license-scanner --version")
    assert_match "| Apache-2.0 |", shell_output("#{bin}/license-scanner --list")

    (testpath/"LICENSE").write <<~EOS
      Copyright (C) 2026 by Homebrew

      Permission to use, copy, modify, and/or distribute this software for any
      purpose with or without fee is hereby granted.

      THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
      REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
      AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
      INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
      LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
      OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
      PERFORMANCE OF THIS SOFTWARE.
    EOS
    assert_match "License ID:\t0BSD", shell_output("#{bin}/license-scanner --file #{testpath}/LICENSE")
  end
end
