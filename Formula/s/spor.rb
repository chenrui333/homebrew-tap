class Spor < Formula
  desc "Automatic project snapshots with branching, unlimited undo history"
  homepage "https://github.com/emprcl/spor"
  url "https://github.com/emprcl/spor/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "ef89cee0ff8b02a96453498c8c8d4247da936855380b3f491805090eae8e9054"
  license "MIT"
  head "https://github.com/emprcl/spor.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8497299d9c4d8abfb68f819ac8b925fdaa5796bc228a86b36abc265e6e22ca80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8497299d9c4d8abfb68f819ac8b925fdaa5796bc228a86b36abc265e6e22ca80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9028333b50740aec118f19e488ef5022a8b530203cd0eff7722c79017144fb7"
    sha256 cellar: :any,                 x86_64_linux:  "91493febbd78e6bb875ae4d4296e22284538250ea50e0742431ca9352dc7cdd9"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/spor"
    generate_completions_from_executable(bin/"spor", shell_parameter_format: :cobra)
    (var/"spor").mkpath
  end

  def caveats
    <<~EOS
      The Homebrew service records snapshots of #{var}/spor.
      To record another project, run `spor watch` from that project's directory.
    EOS
  end

  service do
    run [opt_bin/"spor", "watch"]
    keep_alive true
    working_dir var/"spor"
    log_path var/"log/spor.log"
    error_log_path var/"log/spor.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spor --version")
    project = testpath/"project"
    project.mkpath
    cd project do
      (project/"note.txt").write "original\n"
      system bin/"spor", "snap", "--label", "original"
      File.write(project/"note.txt", "modified\n")
      system bin/"spor", "snap", "--label", "modified"
      system bin/"spor", "go", "original"
      assert_equal "original\n", (project/"note.txt").read
    end
  end
end
