class Critcmp < Formula
  desc "CLI to compare benchmarks run by Criterion"
  homepage "https://github.com/BurntSushi/critcmp"
  url "https://github.com/BurntSushi/critcmp/archive/refs/tags/0.1.8.tar.gz"
  sha256 "b89a2a0a1140dcf11aa66de670c62854212bfd57f674eea6da942b87b267ae9c"
  license any_of: ["Unlicense", "MIT"]
  head "https://github.com/BurntSushi/critcmp.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9050343335e49032699f3d9f88758f5cc1492d185dd6c89a5db9f8f9774f94b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84dbab96c71195d0355da564eb88e29b09fb75d91581efe1c75acaebadf0c3a5"
    sha256 cellar: :any,                 arm64_linux:   "0a77a8c34bf7b8591aec6d2afdd8deb2aaf4cf6b5be8176abee073c359c6be5b"
    sha256 cellar: :any,                 x86_64_linux:  "0d703cdef9fac21acc1d447c0fe14a1ff696b8c857660c21eea74c924b7c8cba"
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
    assert_match version.to_s, shell_output("#{bin}/critcmp --version")

    statistic = lambda do |estimate|
      {
        confidence_interval: { confidence_level: 0.95, lower_bound: estimate, upper_bound: estimate },
        point_estimate:      estimate,
        standard_error:      0,
      }
    end
    { "before" => 1_000_000, "after" => 2_000_000 }.each do |name, nanoseconds|
      benchmark = {
        baseline:               name,
        fullname:               "#{name}/parse/short",
        criterion_benchmark_v1: {
          group_id: "parse", function_id: "short", value_str: nil, throughput: nil,
          full_id: "parse/short", directory_name: "parse_short"
        },
        criterion_estimates_v1: {
          mean: statistic.call(nanoseconds), median: statistic.call(nanoseconds),
          median_abs_dev: statistic.call(0), slope: nil, std_dev: statistic.call(0)
        },
      }
      (testpath/"#{name}.json").write(JSON.generate(name: name, benchmarks: { "parse/short" => benchmark }))
    end

    assert_match "parse/short", shell_output("#{bin}/critcmp before.json after.json -t 50")
    assert_equal "", shell_output("#{bin}/critcmp before.json after.json -t 150", 1)
  end
end
