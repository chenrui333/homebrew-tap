class Nexus < Formula
  desc "Terminal-based HTTP client for REST and gRPC APIs"
  homepage "https://github.com/pranav-cs-1/nexus"
  url "https://github.com/pranav-cs-1/nexus/archive/0906a0fd7799058a35adaf58160d5e2027a59e83.tar.gz"
  version "0.2.1"
  sha256 "e5ca698629a915f4b988c8b91d79059c4ac7ff245ef86cbd24235bd96eedf349"
  license "MIT"
  head "https://github.com/pranav-cs-1/nexus.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    ENV["HOME"] = testpath
    data_dir = if OS.mac?
      testpath/"Library/Application Support/nexus"
    else
      testpath/".local/share/nexus"
    end
    db_path = data_dir/"nexus.db"

    pid = fork do
      exec bin/"nexus"
    end

    begin
      timeout = Time.now + 5
      sleep 0.1 until db_path.exist? || Time.now > timeout
      assert_path_exists db_path
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
