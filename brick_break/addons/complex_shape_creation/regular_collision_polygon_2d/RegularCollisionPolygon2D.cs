using System;
using System.Diagnostics;
using Godot;
using ComplexShapeCreation.MemberNames;

namespace ComplexShapeCreation;

/// <summary>
/// A Wrapper for a <see cref="CollisionShape2D"/> which contains the script specified in <see cref="GDScriptEquivalent"/>.
/// It also provides ways for creating such nodes.
/// </summary>
public class RegularCollisionPolygon2D
{
    /// <inheritdoc cref="SimplePolygon2D.GDScriptEquivalentPath"/>
    public const string GDScriptEquivalentPath = "res://addons/complex_shape_creation/regular_collision_polygon_2d/regular_collision_polygon_2d.gd";
    /// <summary>The loaded <see cref="GDScript"/> of <see cref="GDScriptEquivalentPath"/>.</summary>
    public static readonly GDScript GDScriptEquivalent = GD.Load<GDScript>(GDScriptEquivalentPath);
    private static readonly Lazy<CollisionShape2D> _shared = new(() => GDScriptEquivalent.New().As<CollisionShape2D>());

    /// <summary>The <see cref="GDScriptEquivalent"/> instance this class wraps around.</summary>
    public CollisionShape2D Instance { get; }

    /// <inheritdoc cref="SimplePolygon2D.VerticesCount"/>
    public int VerticesCount
    {
        get => (int)Instance.Get(PropertyName.VerticesCount);
        set => Instance.Set(PropertyName.VerticesCount, value);
    }
    /// <inheritdoc cref="SimplePolygon2D.Size"/>
    public float Size
    {
        get => (float)Instance.Get(PropertyName.Size);
        set => Instance.Set(PropertyName.Size, value);
    }
    /// <inheritdoc cref="SimplePolygon2D.OffsetRotationDegrees"/>
    public float OffsetRotationDegrees
    {
        get => (float)Instance.Get(PropertyName.OffsetRotationDegrees);
        set => Instance.Set(PropertyName.OffsetRotationDegrees, value);
    }
    /// <inheritdoc cref="SimplePolygon2D.OffsetRotation"/>
    public float OffsetRotation
    {
        get => (float)Instance.Get(PropertyName.OffsetRotation);
        set => Instance.Set(PropertyName.OffsetRotation, value);
    }
    /// <summary>Determines the width of the shape.</summary>
    /// <remarks>
    /// It only has an effect with values greater than <c>0</c>.
    /// Values greater than or equal to <see cref="size"/> force the usage of <see cref="ConvexPolygonShape2D"/>.
    /// <br/><br/><b>Note</b>: using this property with lines may not produce the same shape as <see cref="RegularPolygon2D"/>.
    /// </remarks>
    public float Width
    {
        get => (float)Instance.Get(PropertyName.Width);
        set => Instance.Set(PropertyName.Width, value);
    }
    /// <inheritdoc cref="RegularPolygon2D.DrawnArcDegrees"/>
    public float DrawnArcDegrees
    {
        get => (float)Instance.Get(PropertyName.DrawnArcDegrees);
        set => Instance.Set(PropertyName.DrawnArcDegrees, value);
    }
    /// <inheritdoc cref="RegularPolygon2D.DrawnArc"/>
    public float DrawnArc
    {
        get => (float)Instance.Get(PropertyName.DrawnArc);
        set => Instance.Set(PropertyName.DrawnArc, value);
    }
    /// <inheritdoc cref="RegularPolygon2D.CornerSize"/>
    public float CornerSize
    {
        get => (float)Instance.Get(PropertyName.CornerSize);
        set => Instance.Set(PropertyName.CornerSize, value);
    }
    /// <inheritdoc cref="RegularPolygon2D.CornerSmoothness"/>
    public int CornerSmoothness
    {
        get => (int)Instance.Get(PropertyName.CornerSmoothness);
        set => Instance.Set(PropertyName.CornerSmoothness, value);
    }
    /// <inheritdoc cref="SimplePolygon2D.Position"/>
    public Vector2 Position
    {
        get => Instance.Position; 
        set => Instance.Position = value;
    }
    /// <inheritdoc cref="SimplePolygon2D.Rotation"/>
    public float Rotation
    {
        get => Instance.Rotation;
        set => Instance.Rotation = value;
    }
    /// <inheritdoc cref="SimplePolygon2D.RotationDegrees"/>
    public float RotationDegrees
    {
        get => Instance.RotationDegrees;
        set => Instance.RotationDegrees = value;
    }
    /// <inheritdoc cref="SimplePolygon2D.Scale"/>
    public Vector2 Scale
    {
        get => Instance.Scale;
        set => Instance.Scale = value;
    }

    /// <summary>Creates and wraps a <see cref="CollisionShape2D"/> around <paramref name="instance"/>.</summary>
    /// <param name="instance">The instance of <see cref="GDScriptEquivalent"/> to wrap.</param>
    /// <exception cref="ArgumentNullException"><paramref name="instance"/> is <see langword="null"/>.</exception>
    /// <exception cref="ArgumentException"><paramref name="instance"/> isn't a instance of <see cref="GDScriptEquivalent"/>.</exception>
    public RegularCollisionPolygon2D(CollisionShape2D instance)
    {
        if (instance is null)
            throw new ArgumentNullException(nameof(instance));
        if (GDScriptEquivalent != instance.GetScript().As<GDScript>())
            throw new ArgumentException($"must have attached script '{GDScriptEquivalentPath}'.", nameof(instance));

        Instance = instance;
    }
    /// <inheritdoc cref="New"/>
    /// <summary>Creates an instance of <see cref="GDScriptEquivalent"/> wrapped by a new <see cref="CollisionShape2D"/>.</summary>
    /// <remarks>See also: <seealso cref="New"/>.</remarks>
    public RegularCollisionPolygon2D(int verticesCount = 1, float size = 10, float offsetRotation = 0,
        float width = 0, float drawnArc = Mathf.Tau, float cornerSize = 0, int cornerSmoothness = 0)
    => Instance = RegularCollisionPolygon2D.New(verticesCount, size, offsetRotation, width, drawnArc, cornerSize, cornerSmoothness);

    /// <inheritdoc cref="RegularPolygon2D.New)"/>
    /// <summary>Creates an instance of <see cref="GDScriptEquivalent"/> with the specified parameters.</summary>
    public static CollisionShape2D New(int verticesCount = 1, float size = 10, float offsetRotation = 0,
        float width = 0, float drawnArc = Mathf.Tau, float cornerSize = 0, int cornerSmoothness = 0)
    => GDScriptEquivalent.New(verticesCount, size, offsetRotation, width, drawnArc, cornerSize, cornerSmoothness).As<CollisionShape2D>();

    /// <summary>
    /// Queues <see cref="Regenerate"/> for the next process frame. If this method is called multiple times, the shape is only regenerated once.
    /// </summary>
    /// <remarks>This method does nothing if the node is outside the <see cref="SceneTree"/>. Use <see cref="Regenerate"/> instead.</remarks>
    public void QueueRegenerate()
    => Instance.Call(MethodName.QueueRegenerate);

    /// <summary>
    /// Regenerates the <see cref="CollisionShape2D.Shape"/> using the properties of this node.
    /// </summary>
    public void Regenerate()
    => Instance.Call(MethodName.Regenerate);

    /// <summary>
    /// Returns a modified copy of <paramref name="segments"/> to form an outline of the interconnected segments with the given <paramref name="width"/>.
    /// </summary>
    /// <remarks>
    /// For disconnected segments, use <see cref="WidenMultiline"/>.
    /// </remarks>
    /// <param name="segments">The pairs of points representing each segment (see <seealso cref="ConcavePolygonShape2D.Segments"/>).</param>
    /// <param name="width">The width of each segment</param>
    /// <param name="joinPerimeter">Controls whether the function should extend (or shorten) line segments to form a property closed shape.</param>
    public static Vector2[] WidenPolyline(Vector2[] segments, float width, bool joinPerimeter)
    => _shared.Value.Call(MethodName.WidenPolyline, segments, width, joinPerimeter).AsVector2Array();

    /// <summary>
    /// Returns a modified copy of <paramref name="segments"/> to form an outline of every disconnected segment with the given <paramref name="width"/>.
    /// </summary>
    /// <remarks>
    /// For interconnected segments, use <see cref="WidenPolyline"/>.
    /// </remarks>
    /// <param name="segments">The pairs of points representing each segment (see <seealso cref="ConcavePolygonShape2D.Segments"/>).</param>
    /// <param name="width">The width of each segment</param>
    public static Vector2[] WidenMultiline(Vector2[] segments, float width)
    => _shared.Value.Call(MethodName.WidenMultiline, segments, width).AsVector2Array();

    public static implicit operator CollisionShape2D(RegularCollisionPolygon2D instance) => instance.Instance;
    public static explicit operator RegularCollisionPolygon2D(CollisionShape2D instance) => new(instance);
}
