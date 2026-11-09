class Critcmp < Formula
  desc "CLI to compare benchmarks run by Criterion"
  homepage "https://github.com/BurntSushi/critcmp"
  url "https://github.com/BurntSushi/critcmp/archive/refs/tags/0.1.8.tar.gz"
  sha256 "b89a2a0a1140dcf11aa66de670c62854212bfd57f674eea6da942b87b267ae9c"
  license any_of: ["Unlicense", "MIT"]
  head "https://github.com/BurntSushi/critcmp.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c44476df526e3d81bdb9861eaa34ef46334ade6c0e8588e4d7079c2dd0a25fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43f34408ad5da29259e0010ff5e52a3231ffa9e5911ab59ad83ad98e1754e275"
    sha256 cellar: :any_skip_relocation, ventura:       "734c260f105c3d442ea79fcf85642421697c368e35de34daa2d6e2389c91953a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5ec9cfb442a982487a8bf58b560e411e4518a836d440ac2d16f3f29db02f481"
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
