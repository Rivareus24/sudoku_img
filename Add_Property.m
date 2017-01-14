function Struct = Add_Property(Struct, property_name, property_value)

    if isprop(Struct, property_name)
        [Struct(:).(property_name)] = property_value;
    else
        Struct.(property_name) = property_value;
    end

end
