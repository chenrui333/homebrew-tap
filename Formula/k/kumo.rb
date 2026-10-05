class Kumo < Formula
  desc "Lightweight AWS service emulator written in Go"
  homepage "https://github.com/sivchari/kumo"
  url "https://github.com/sivchari/kumo/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "a092c233721c3267f3885d99061e9b710be38f04aab55eb1d4aaeca9668177f8"
  license "MIT"
  head "https://github.com/sivchari/kumo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "679e9c1aa4889ffbc7fe56ee19f51143ce763cc62f354183a09d345879551623"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "679e9c1aa4889ffbc7fe56ee19f51143ce763cc62f354183a09d345879551623"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a1b49e092ebe55143b5473ab7b6cf26504fe1472cfc418026dd53bf94fe27e5"
    sha256 cellar: :any,                 x86_64_linux:  "a5b0ad5c3bd953c0b08a9c1aa5d754030c2a0af91c1f46eb13a0ef8de33c2a32"
  end

  depends_on "go" => :build

  # kumo is a local AWS emulator server; the test checks its loopback health endpoint.
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    (var/"kumo").mkpath

    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/kumo"
  end

  service do
    run [opt_bin/"kumo"]
    keep_alive true
    working_dir var/"kumo"
    environment_variables KUMO_DATA_DIR: var/"kumo"
  end

  test do
    log_file = testpath/"kumo.log"
    data_dir = testpath/"data"

    pid = spawn({ "KUMO_DATA_DIR" => data_dir.to_s },
                bin/"kumo",
                [:out, :err] => log_file.to_s)

    begin
      15.times do
        break if quiet_system "curl", "-fsS", "http://127.0.0.1:4566/health"

        sleep 1
      end

      assert_match '{"status":"healthy"}', shell_output("curl -fsS http://127.0.0.1:4566/health")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
