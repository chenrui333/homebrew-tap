class Pproftui < Formula
  desc "TUI for Go pprof data"
  homepage "https://github.com/Oloruntobi1/pproftui"
  url "https://github.com/Oloruntobi1/pproftui/archive/d94a02c55dcdfc0bd2617acc9a1b98079bf990d8.tar.gz"
  version "0.0.1"
  sha256 "1538131099b317c33c7b0864aee888dd2c8af18e330734a751d3b22d0c81c379"
  license "MIT"
  head "https://github.com/Oloruntobi1/pproftui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eaca328f768c2b1ba61726b7a7ae905aa34e8ac370b708c0fffa52ce1079432c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eaca328f768c2b1ba61726b7a7ae905aa34e8ac370b708c0fffa52ce1079432c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac6fbc8977d912d315ca6af2db26f71d538fb27562fa7b6905f7d68825bb98c2"
    sha256 cellar: :any,                 x86_64_linux:  "5dc1bc3d2783117334d1cd1950196e633359f4befabdb6b6d8bc8611f4edde10"
  end

  depends_on "go" => [:build, :test]

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Usage of", shell_output("#{bin}/pproftui -h 2>&1")

    # Generate a heap profile locally instead of downloading one.
    (testpath/"prof.go").write <<~GO
      package main

      import (
      	"os"
      	"runtime/pprof"
      )

      func main() {
      	f, _ := os.Create("heap.pprof")
      	pprof.WriteHeapProfile(f)
      	f.Close()
      }
    GO
    system "go", "run", testpath/"prof.go"
    assert_path_exists testpath/"heap.pprof"

    output_log = testpath/"output.log"
    pid = if OS.mac?
      spawn "script", "-q", File::NULL,
            bin/"pproftui", testpath/"heap.pprof",
            [:out, :err] => output_log.to_s
    else
      spawn "script", "-q", "-c", "#{bin}/pproftui #{testpath}/heap.pprof", File::NULL,
            [:out, :err] => output_log.to_s
    end

    sleep 2
    Process.kill("TERM", pid) if Process.waitpid(pid, Process::WNOHANG).nil?
    Process.wait(pid)

    output = output_log.read
    assert_match "\e[?1049h", output
    assert_match "View: alloc_objects", output
    refute_match "No such device or address", output
  rescue Errno::ESRCH
    output = output_log.exist? ? output_log.read : ""
    assert_match "\e[?1049h", output
    refute_match "No such device or address", output
  end
end
