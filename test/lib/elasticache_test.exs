defmodule ExAws.ElastiCacheTest do
  use ExUnit.Case, async: true
  alias ExAws.ElastiCache
  alias ExAws.Operation.Query

  doctest ExAws.ElastiCache

  @version "2015-02-02"

  defp build_request(action, params \\ %{}) do
    action_param = action |> Atom.to_string |> Macro.camelize

    %Query{
      params: params |> Map.merge(%{"Version" => @version, "Action" => action_param}),
      path: "/",
      service: :elasticache,
      action: action
    }
  end

  test "authorize_cache_security_group_ingress" do
    expected = build_request(:authorize_cache_security_group_ingress,
      %{
        "CacheSecurityGroupName" => "MyGroup",
        "EC2SecurityGroupName" => "default",
        "EC2SecurityGroupOwnerId" => "1234-5678-1234"
        })

    assert expected == ElastiCache.authorize_cache_security_group_ingress("MyGroup", "default", "1234-5678-1234")
  end

  test "copy_snapshot" do
    expected = build_request(:copy_snapshot,
      %{
        "SourceSnapshotName" => "SourceSnap",
        "TargetSnapshotName" => "TargetSnap"
        })

    assert expected == ElastiCache.copy_snapshot("SourceSnap", "TargetSnap")
  end

  test "create_cache_cluster no optional params" do
    expected = build_request(:create_cache_cluster,
      %{
        "CacheClusterId" => "TestCacheClusterId",
        "CacheNodeType" => "cache.t3.medium",
        "Engine" => "redis",
        "NumCacheNodes" => 3
      })

    assert expected == ElastiCache.create_cache_cluster("TestCacheClusterId", "cache.t3.medium", "redis", 3)
  end

  test "create_cache_cluster optional params" do
    expected = build_request(:create_cache_cluster,
      %{
        "CacheClusterId" => "TestCacheClusterId",
        "CacheNodeType" => "cache.t3.medium",
        "Engine" => "redis",
        "NumCacheNodes" => 3,
        "CacheSecurityGroupNames.CacheSecurityGroupName.1" => "default",
        "PreferredAvailabilityZones.PreferredAvailabilityZone.1" => "us-east-1a",
        "PreferredAvailabilityZones.PreferredAvailabilityZone.2" => "us-east-1b",
        "PreferredAvailabilityZones.PreferredAvailabilityZone.3" => "us-east-1c",
        "Port" => 8083
      })

    assert expected == ElastiCache.create_cache_cluster("TestCacheClusterId", "cache.t3.medium", "redis", 3,
      [cache_security_group_names: ["default"],
       preferred_availability_zones: ["us-east-1a", "us-east-1b", "us-east-1c"],
       port: 8083
      ])
  end

  test "create_replication_group no optional params" do
    expected = build_request(:create_replication_group,
      %{
        "ReplicationGroupId" => "myrepgroup",
        "ReplicationGroupDescription" => "My Rep Group"
      })

    assert expected == ElastiCache.create_replication_group("myrepgroup", "My Rep Group")
  end

  test "create_replication_group with optional params" do
    expected = build_request(:create_replication_group,
      %{
        "ReplicationGroupId" => "myrepgroup",
        "ReplicationGroupDescription" => "My Rep Group",
        "NodeGroupConfigurations.NodeGroupConfiguration.1.PrimaryAvailabilityZone" => "us-east-1a",
        "NodeGroupConfigurations.NodeGroupConfiguration.1.ReplicaAvailabilityZones.AvailabilityZone.1" => "us-east-1b",
        "NodeGroupConfigurations.NodeGroupConfiguration.1.ReplicaAvailabilityZones.AvailabilityZone.2" => "us-east-1c",
        "NodeGroupConfigurations.NodeGroupConfiguration.1.ReplicaCount" => 2,
        "NodeGroupConfigurations.NodeGroupConfiguration.1.Slots" => 0,
        "Tags.Tag.1.Key" => "Name",
        "Tags.Tag.1.Value" => "myrepgroup",
        "CacheNodeType" => "cache.t3.medium",
        "Engine" => "redis"
      })

    assert expected == ElastiCache.create_replication_group("myrepgroup", "My Rep Group",
      [ node_group_configurations: [
          %{
            primary_availability_zone: "us-east-1a",
            replica_availability_zones: ["us-east-1b", "us-east-1c"],
            replica_count: 2,
            slots: 0
          }
        ],
        tags: [ "Name": "myrepgroup" ],
        cache_node_type: "cache.t3.medium",
        engine: "redis"
      ])
  end

  test "create_replication_group with more optional params" do
    expected = build_request(:create_replication_group,
      %{
        "ReplicationGroupId" => "myrepgroup",
        "ReplicationGroupDescription" => "My Rep Group",
        "PreferredCacheClusterAZs.AvailabilityZone.1" => "us-east-1a",
        "PreferredCacheClusterAZs.AvailabilityZone.2" => "us-east-1b"
        })

    assert expected == ElastiCache.create_replication_group("myrepgroup", "My Rep Group",
        [preferred_cache_cluster_azs: ["us-east-1a", "us-east-1b"]])
  end

  test "delete_cache_cluster no optional params" do
    expected = build_request(:delete_cache_cluster,
      %{
        "CacheClusterId" => "TestCacheClusterId"
      })

    assert expected == ElastiCache.delete_cache_cluster("TestCacheClusterId")
  end

  test "delete_cache_cluster optional params" do
    expected = build_request(:delete_cache_cluster,
      %{
        "CacheClusterId" => "TestCacheClusterId",
        "FinalSnapshotIdentifier" => "SnapshotIdentifier"
      })

    assert expected == ElastiCache.delete_cache_cluster("TestCacheClusterId",
      [final_snapshot_identifier: "SnapshotIdentifier"])
  end

  test "describe_cache_clusters no optional params" do
    assert build_request(:describe_cache_clusters) == ElastiCache.describe_cache_clusters
  end

  test "describe_cache_clusters optional params" do
    expected = build_request(:describe_cache_clusters,
      %{
        "CacheClusterId" => "TestCacheClusterId",
        "MaxRecords" => 100,
        "ShowCacheNodeInfo" => true,
        "ShowCacheClustersNotInReplicationGroup" => true
      })

    assert expected == ElastiCache.describe_cache_clusters(
      [
        cache_cluster_id: "TestCacheClusterId",
        max_records: 100,
        show_cache_node_info: true,
        show_cache_clusters_not_in_replication_group: true
      ]
    )
  end

  test "delete_replication_group no optional params" do
    expected = build_request(:delete_replication_group,
      %{
        "ReplicationGroupId" => "MyRepGroup"
      })
    assert expected == ElastiCache.delete_replication_group("MyRepGroup")
  end

  test "delete_replication_group with optional params" do
    expected = build_request(:delete_replication_group,
      %{
        "ReplicationGroupId" => "MyRepGroup",
        "FinalSnapshotIdentifier" => "SnapshotIdentifier",
        "RetainPrimaryCluster" => false
      })

    assert expected == ElastiCache.delete_replication_group("MyRepGroup", [
      final_snapshot_identifier: "SnapshotIdentifier",
      retain_primary_cluster: false
      ])
  end

  test "describe_cache_engine_versions no optional params" do
    assert build_request(:describe_cache_engine_versions) == ElastiCache.describe_cache_engine_versions
  end

  test "describe_cache_engine_versions with optional params" do
    expected = build_request(:describe_cache_engine_versions,
      %{
        "CacheParameterGroupFamily" => "memcached1.4",
        "DefaultOnly" => false,
        "Engine" => "memcached",
        "EngineVersion" => "1.4.14",
        "MaxRecords" => 200
        })

    assert expected == ElastiCache.describe_cache_engine_versions(
      [
        cache_parameter_group_family: "memcached1.4",
        default_only: false,
        engine: "memcached",
        engine_version: "1.4.14",
        max_records: 200
      ])
  end

  test "describe_replication_groups no optional params" do
    assert build_request(:describe_replication_groups) == ElastiCache.describe_replication_groups
  end

  test "describe_replication_groups with optional params" do
    expected = build_request(:describe_replication_groups,
      %{
        "Marker" =>  "TestMarker",
        "MaxRecords" => 100,
        "ReplicationGroupId" => "TestReplicationGroup"
      })

    assert expected == ElastiCache.describe_replication_groups(
      [marker: "TestMarker", max_records: 100, replication_group_id: "TestReplicationGroup"]
    )
  end

  test "reboot_cache_cluster" do
    expected = build_request(:reboot_cache_cluster,
      %{
        "CacheClusterId" => "MyCache",
        "CacheNodeIdsToReboot.CacheNodeId.1" => "0001",
        "CacheNodeIdsToReboot.CacheNodeId.2" => "0002",
        "CacheNodeIdsToReboot.CacheNodeId.3" => "0003"
      })

    assert expected == ElastiCache.reboot_cache_cluster("MyCache", ["0001", "0002", "0003"])
  end
end
