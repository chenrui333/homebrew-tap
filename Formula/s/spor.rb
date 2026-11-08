class Spor < Formula
  desc "Automatic project snapshots with branching, unlimited undo history"
  homepage "https://github.com/emprcl/spor"
  url "https://github.com/emprcl/spor/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "ef89cee0ff8b02a96453498c8c8d4247da936855380b3f491805090eae8e9054"
  license "MIT"
  head "https://github.com/emprcl/spor.git", branch: "main"

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
