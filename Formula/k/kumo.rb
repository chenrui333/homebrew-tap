class Kumo < Formula
  desc "Lightweight AWS service emulator written in Go"
  homepage "https://github.com/sivchari/kumo"
  url "https://github.com/sivchari/kumo/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "a092c233721c3267f3885d99061e9b710be38f04aab55eb1d4aaeca9668177f8"
  license "MIT"
  head "https://github.com/sivchari/kumo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4691a045cb5cf4a6f9c2d6ebe4dac086acefbbf91eda6838df5af3a4d1ede660"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4691a045cb5cf4a6f9c2d6ebe4dac086acefbbf91eda6838df5af3a4d1ede660"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "286e1984c0bcbb9f4f1a2ad471a62c137189a48d5a77343bb1a1fd245b7043e9"
    sha256 cellar: :any,                 x86_64_linux:  "29a95b00dd82aa34e8be44dabdc3ea60cf5ce19c5b392dcda4027ca3da5e91d3"
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
