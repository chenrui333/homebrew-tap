class Envy < Formula
  desc "Terminal-based tool for managing secrets with TUI and CLI support"
  homepage "https://github.com/XENONCYBER/envy"
  url "https://github.com/XENONCYBER/envy/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "d5afc129b2a517f6d103eee4ae84a8ae08ca70327de5dff4c3f39da85c99c1ab"
  license "MIT"
  head "https://github.com/XENONCYBER/envy.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "caf8b6d43837ac385c3b655df41f6a3bd41da5b4573c5f1c3d20b2df577aa076"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "caf8b6d43837ac385c3b655df41f6a3bd41da5b4573c5f1c3d20b2df577aa076"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "caf8b6d43837ac385c3b655df41f6a3bd41da5b4573c5f1c3d20b2df577aa076"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b5da76e473d3208479bd76f40d860b62035b2643d60cb55a0c1a2cca4a4e5ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec2b6d0382b0e4aacdfdbc11d01346a7ec0a947dfc7c075db89b5509afff4206"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"envy"), "./cmd/main.go"
    generate_completions_from_executable(bin/"envy", "completion", shell_parameter_format: :cobra)
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
