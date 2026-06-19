class Envy < Formula
  desc "Terminal-based tool for managing secrets with TUI and CLI support"
  homepage "https://github.com/XENONCYBER/envy"
  url "https://github.com/XENONCYBER/envy/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "d5afc129b2a517f6d103eee4ae84a8ae08ca70327de5dff4c3f39da85c99c1ab"
  license "MIT"
  head "https://github.com/XENONCYBER/envy.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd17f88e01f44fe2700f24c6b15ae067fe13b89fdc6cebd8e30c74f34c8c2a18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd17f88e01f44fe2700f24c6b15ae067fe13b89fdc6cebd8e30c74f34c8c2a18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd17f88e01f44fe2700f24c6b15ae067fe13b89fdc6cebd8e30c74f34c8c2a18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "682df3b212918b1f89b6cd462aafb68c654d0da75f8fa34e52b37112600252ec"
    sha256 cellar: :any,                 x86_64_linux:  "8e21cf089144ba1ca3b3b82585d1e1723d3085c3ab2c5109c494779cf3e8651d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"envy"), "./cmd/main.go"
    generate_completions_from_executable(bin/"envy", shell_parameter_format: :cobra)
  end

  test do
    home = testpath/"home"
    (home/".envy").mkpath
    (home/".envy/keys.json").write <<~JSON
      {
        "version": 1,
        "salt": "mVBgU7J5SGiU4WJKPf6v2Q==",
        "auth_hash": "C34M+SBi/yefTAOCd1X+qUm5tFhuCUmkNReo5n0HPLQ=",
        "projects": [
          {
            "name": "proj",
            "environment": "dev",
            "keys": [
              {
                "title": "FOO",
                "key": "FOO",
                "current": {
                  "value": "YUJ2TsJZXZBs+1nW82ZISDwUh8MEoLX087sCUrcoVA==",
                  "created_at": "2026-03-22T17:59:24Z",
                  "created_by": "cli-import"
                },
                "history": []
              }
            ]
          }
        ]
      }
    JSON

    export_cmd = if OS.mac?
      "script -q /dev/null #{bin}/envy -t proj"
    else
      "script -q -c '#{bin}/envy -t proj' /dev/null"
    end

    output = pipe_output("HOME=#{home} #{export_cmd}", "password123\n")
    assert_match "Exported project 'proj' to .env", output
    assert_match "FOO=bar", (testpath/".env").read
    assert_match version.to_s, shell_output("#{bin}/envy --version")
  end
end
